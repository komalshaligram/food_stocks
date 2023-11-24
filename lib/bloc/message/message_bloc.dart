import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:food_stock/data/model/req_model/get_messages_req_model/get_messages_req_model.dart';
import 'package:food_stock/data/model/res_model/get_messages_res_model/get_messages_res_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/error/exceptions.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_colors.dart';
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
        SharedPreferencesHelper preferences =
        SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
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
              )
          );
          GetMessagesResModel response = GetMessagesResModel.fromJson(res);
          debugPrint(
              'getMessage   url  = ${AppUrls.baseUrl}${AppUrls.getNotificationMessageUrl}');

          debugPrint('getMessage response  = ${response}');

          if (response.status == 200) {
            List<MessageData> messageList =
                state.messageList.toList(growable: true);
            messageList.addAll(response.data
                ?.map((message) => MessageData(
              id: message.id,
              isRead: message.isRead,
              message:Message(
                id: message.message?.id ?? '',
                title: message.message?.title ?? '',
                summary: message.message?.summary ?? '',
                body: message.message?.body ?? '',
              ),
              createdAt: message.createdAt,
              updatedAt: message.updatedAt,
            ))
                .toList() ??
                []);
           /* messageList.removeWhere(
                (message) => (message.isPushNotification ?? false) == false);*/
            debugPrint('new message list len = ${messageList.length}');
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
            showSnackBar(
                context: event.context,
                title: response.message ?? AppStrings.somethingWrongString,
                bgColor: AppColors.mainColor);
          }
        } on ServerException {
          emit(state.copyWith(isLoadMore: false));
        }
      }
    });
  }
}
