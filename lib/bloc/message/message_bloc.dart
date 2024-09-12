import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:food_stock/data/model/req_model/get_messages_req_model/get_messages_req_model.dart';
import 'package:food_stock/data/model/res_model/get_messages_res_model/get_messages_res_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/req_model/delete_message_req/delete_message_req.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_constants.dart';
import '../../ui/utils/themes/app_strings.dart';
import '../../ui/utils/themes/app_urls.dart';

part 'message_event.dart';

part 'message_state.dart';

part 'message_bloc.freezed.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  MessageBloc() : super(MessageState.initial()) {
    on<MessageEvent>((event, emit) async {
      if (event is _GetMessageListEvent) {
        SharedPreferencesHelper preferences = SharedPreferencesHelper(
            prefs: await SharedPreferences.getInstance());
        emit(state.copyWith(language: preferences.getAppLanguage()));
        if (state.isLoadMore) {
          return;
        }
        if (state.isBottomOfMessage) {
          return;
        }
        try {
          emit(state.copyWith(
              isShimmering: state.pageNum == 0 ? true : false,
              isLoadMore: state.pageNum == 0 ? false : true));
          final res = await DioClient(event.context).post(
              //AppUrls.getAllMessagesUrl,
              AppUrls.getNotificationMessageUrl,
              data: GetMessagesReqModel(
                      pageNum: state.pageNum + 1,
                      pageLimit: AppConstants.messagePageLimit)
                  .toJson(),
              options: Options(
                headers: {
                  HttpHeaders.authorizationHeader:
                      'Bearer ${preferences.getAuthToken()}',
                },
              ));
          GetMessagesResModel response = GetMessagesResModel.fromJson(res);

          if (response.status == AppConstants.code_200) {
            List<MessageData> messageList =
                state.messageList.toList(growable: true);
            messageList.addAll(response.data
                    ?.map((message) => MessageData(
                          id: message.id,
                          isRead: message.isRead,
                          message: Message(
                            id: message.message?.id ?? '',
                            title: message.message?.title ?? '',
                            summary: message.message?.summary ?? '',
                            body: message.message?.body ?? '',
                            messageImage: message.message?.messageImage ?? '',
                            subPage: message.message?.subPage?? '',
                            mainPage: message.message?.mainPage ?? '',
                            navigationId: message.message?.navigationId ?? ''
                          ),
                          createdAt: message.createdAt,
                          updatedAt: message.updatedAt,
                        ))
                    .toList() ??
                []);

            emit(state.copyWith(
                messageList: messageList,
                pageNum: state.pageNum + 1,
                isLoadMore: false,
                isShimmering: false));
            emit(state.copyWith(
                isBottomOfMessage: messageList.length ==
                        (response.metaData?.totalFilteredCount ?? 0)
                    ? true
                    : false));
          } else {
            emit(state.copyWith(isLoadMore: false));

          }
        } on ServerException {
          emit(state.copyWith(isLoadMore: false));
        }
        state.refreshController.refreshCompleted();
        state.refreshController.loadComplete();
      } else if (event is _refreshListEvent) {
        emit(state.copyWith(
            pageNum: 0, messageList: [], isBottomOfMessage: false));
        add(MessageEvent.getMessageListEvent(context: event.context));
      }
      else if (event is _removeOrUpdateMessageEvent) {
        List<MessageData> messageList =
            state.messageList.toList(growable: true);
        SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(
            prefs: await SharedPreferences.getInstance());

        if (event.isRead) {
          if (messageList[messageList.indexOf(messageList
              .firstWhere((message) => message.id == event.messageId))]
              .isRead ==
              false) {
            await preferencesHelper.setMessageCount(
                count: preferencesHelper.getMessageCount() - 1);
            messageList[messageList.indexOf(messageList
                .firstWhere((message) => message.id == event.messageId))] =
                messageList[messageList.indexOf(messageList.firstWhere(
                        (message) => message.id == event.messageId))]
                    .copyWith(isRead: true);
          }
        }
        if (event.isDelete) {
          String deletedMessageId = messageList
              .firstWhere((message) => message.id == event.messageId)
              .id ??
              '';
          messageList.removeWhere((message) => message.id == event.messageId);
          if (deletedMessageId != '') {
            List<String> deletedMessageList =
            state.deletedMessageList.toList(growable: true);
            deletedMessageList.add(deletedMessageId);
            emit(state.copyWith(deletedMessageList: deletedMessageList));
          }
        }
        emit(state.copyWith(messageList: messageList));
      }

      else if(event is _messageDeleteEvent){
        try {
          DeleteMessageReq reqMap = DeleteMessageReq(
            notificationIds: [
              event.messageId,
            ],
          );
          final response =
          await DioClient(event.context).post(AppUrls.deleteMessageUrl,
              data: reqMap,
            );


          if (response[AppStrings.statusString] == AppConstants.code_200) {
              add(MessageEvent.refreshListEvent(context: event.context));
            Navigator.pop(event.dialogContext);

          } else {
            CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(
                    response[AppStrings.messageString].toString().toLocalization() ,
                    event.context),
                type: SnackBarType.failure);
          }
        }
        catch(e){
        }
      }
    });
  }
}
