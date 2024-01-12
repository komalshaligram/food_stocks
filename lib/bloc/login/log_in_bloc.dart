import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_urls.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/req_model/login_req_model/login_req_model.dart';
import '../../data/model/res_model/login_res_model/login_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';

import '../../ui/utils/themes/app_strings.dart';

part 'log_in_event.dart';

part 'log_in_state.dart';

part 'log_in_bloc.freezed.dart';

class LogInBloc extends Bloc<LogInEvent, LogInState> {
  LogInBloc() : super(LogInState.initial()) {
    on<LogInEvent>((event, emit) async {
      if (state.isLoading) {
        return;
      }
      SharedPreferencesHelper preferencesHelper =
          SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());

      if (event is _logInApiDataEvent) {
        emit(state.copyWith(isLoading: true));
        try {
          LoginReqModel reqMap = LoginReqModel(
              contact: event.contactNumber, isRegistration: state.isRegister);
          debugPrint(
              'login req = ${event.contactNumber}___${state.isRegister}');
          debugPrint('url3 = ${AppUrls.existingUserLoginUrl}');
          final res = await DioClient(event.context).post(
            AppUrls.existingUserLoginUrl,
            data: reqMap,
          );

          LoginResModel response = LoginResModel.fromJson(res);
          debugPrint('token_____${preferencesHelper.getFCMToken()}');

          //    debugPrint('login response --- ${response}');

          if (response.status == 200) {
            preferencesHelper.setUserId(id: response.user?.id ?? '');
            preferencesHelper.setPhoneNumber(
                userPhoneNumber: event.contactNumber);
            emit(state.copyWith(isLoginSuccess: true, isLoading: false));
          } else {
            debugPrint(response.message!.toLocalization());
            CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(
                    response.message?.toLocalization() ??
                        'something_is_wrong_try_again',
                    event.context),
                type: SnackBarType.FAILURE);
            emit(state.copyWith(
              isLoading: false,
            ));
          }
        } on ServerException {
          emit(state.copyWith(
            isLoading: false,
          ));
        } catch (e) {
          emit(state.copyWith(
            isLoading: false,
          ));
        }
      } else if (event is _ChangeAuthEvent) {
        emit(state.copyWith(isRegister: event.isRegister));
      }
    });
  }
}
