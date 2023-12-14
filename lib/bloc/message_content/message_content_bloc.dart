import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:food_stock/data/model/res_model/get_messages_res_model/get_messages_res_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/error/exceptions.dart';
import '../../data/model/req_model/delete_message_req/delete_message_req.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/themes/app_strings.dart';
import '../../ui/utils/themes/app_urls.dart';

part 'message_content_event.dart';

part 'message_content_state.dart';

part 'message_content_bloc.freezed.dart';

class MessageContentBloc
    extends Bloc<MessageContentEvent, MessageContentState> {
  MessageContentBloc() : super(MessageContentState.initial()) {
    on<MessageContentEvent>((event, emit) async {
      SharedPreferencesHelper preferences =
          SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());

      if (event is _GetMessageDataEvent) {
        emit(state.copyWith(
            message: event.messageData, isReadMore: event.isReadMore));
      } else if (event is _MessageDeleteEvent) {
        try {
          DeleteMessageReq reqMap = DeleteMessageReq(
            notificationIds: [
              event.messageId,
            ],
          );
          debugPrint('DeleteMessage req  = ${reqMap}');
          final response =
              await DioClient(event.context).post(AppUrls.deleteMessageUrl,
                  data: reqMap,
                  options: Options(
                    headers: {
                      HttpHeaders.authorizationHeader:
                          'Bearer ${preferences.getAuthToken()}',
                    },
                  ));

          debugPrint(
              'DeleteMessage url  = ${AppUrls.baseUrl}${AppUrls.deleteMessageUrl}');

          debugPrint('DeleteMessage response  = ${response}');

          if (response[AppStrings.statusString] == 200) {
            Navigator.pop(event.dialogContext);
            Navigator.pop(event.context, {
              AppStrings.messageIdString: event.messageId,
              AppStrings.messageReadString: !(state.message.isRead ?? true),
              AppStrings.messageDeleteString: true,
            });
          } else {
            /* showSnackBar(
                context: event.context,
                title: response[AppStrings.messageString],
                bgColor: AppColors.mainColor);*/
          }
        } on ServerException {}
      } else if (event is _MessageUpdateEvent) {
        try {
          DeleteMessageReq reqMap = DeleteMessageReq(
            notificationIds: [
              event.messageId,
            ],
          );
          debugPrint('UpdateMessage req  = ${reqMap}');
          final response = await DioClient(event.context).put(
              path: AppUrls.updateMessageUrl,
              data: reqMap.toJson(),
              options: Options(
                headers: {
                  HttpHeaders.authorizationHeader:
                      'Bearer ${preferences.getAuthToken()}',
                },
              ));

          debugPrint(
              'UpdateMessage  url  = ${AppUrls.baseUrl}${AppUrls.updateMessageUrl}');

          debugPrint('UpdateMessage response  = ${response}');

          if (response[AppStrings.statusString] == 200) {
          } else {
            /* showSnackBar(
                context: event.context,
                title: response[AppStrings.messageString],
                bgColor: AppColors.mainColor);*/
          }
        } on ServerException {}
      }

      else if(event is _ImagePreviewEvent){
        emit(state.copyWith(isPreview: !state.isPreview));
      }
    });
  }
}
