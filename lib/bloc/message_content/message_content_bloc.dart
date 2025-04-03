import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../data/model/res_model/get_messages_res_model/get_messages_res_model.dart';
import '../../ui/utils/constants/app_constants.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/error/exceptions.dart';
import '../../data/model/req_model/delete_message_req/delete_message_req.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/constants/app_strings.dart';
import '../../ui/utils/constants/app_urls.dart';

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
            message: event.messageData, isReadMore: event.isReadMore,language: preferences.getAppLanguage()));
      } else if (event is _messageDeleteEvent) {
        emit(state.copyWith(isLoading : true));
        try {
          DeleteMessageReq reqMap = DeleteMessageReq(
            notificationIds: [
              event.messageId,
            ],
          );
          final response =
              await DioClient(event.context).post(AppUrlEndPoints.deleteMessageUrl,
                  data: reqMap,
                );

          if (response[AppStrings.statusString] == AppConstants.code_200) {
            emit(state.copyWith(isLoading : false));
            Navigator.pop(event.dialogContext);
            Navigator.pop(event.context, {
              AppStrings.messageIdString: event.messageId,
              AppStrings.messageReadString: !(state.message.isRead ?? true),
              AppStrings.messageDeleteString: true,
            });
          } else {
            emit(state.copyWith(isLoading : false));

          }

        } on ServerException {
          emit(state.copyWith(isLoading : false));
        }
        catch(e){
           CustomSnackBar.showSnackBar(
                context: event.context,
                title: e.toString(),
                type: SnackBarType.success);
        }

      } else if (event is _messageUpdateEvent) {
        try {
          DeleteMessageReq reqMap = DeleteMessageReq(
            notificationIds: [
              event.messageId,
            ],
          );
          final response = await DioClient(event.context).put(
              path: AppUrlEndPoints.updateMessageUrl,
              data: reqMap.toJson(),
              options: Options(
                headers: {
                  HttpHeaders.authorizationHeader:
                      'Bearer ${preferences.getAuthToken()}',
                },
              ));


          if (response[AppStrings.statusString] == AppConstants.code_200) {
          } else {
            /* CustomSnackBar.showSnackBar(
                context: event.context,
                title: response[AppStrings.messageString],
                type: SnackBarType.SUCCESS);*/
          }
        } on ServerException {}
      }

      else if(event is _imagePreviewEvent){
        emit(state.copyWith(isPreview: !state.isPreview));
      }
    });
  }
}
