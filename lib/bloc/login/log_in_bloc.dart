import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_urls.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/req_model/login_req_model/login_req_model.dart';
import '../../data/model/res_model/login_res_model/login_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';

import '../../routes/app_routes.dart';
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
              'login req = ${reqMap.toJson()}');
          debugPrint('url3 = ${AppUrls.existingUserLoginUrl}');
          final res = await DioClient(event.context).post(
            AppUrls.existingUserLoginUrl,
            data: reqMap,
          );

          LoginResModel response = LoginResModel.fromJson(res);
          debugPrint('token_____${preferencesHelper.getFCMToken()}');

          //    debugPrint('login response --- ${response}');

          if (response.status == 200) {

            await SmsAutoFill().listenForCode();
            print('getAppSignature_______${SmsAutoFill().getAppSignature}');
            preferencesHelper.setUserId(id: response.user?.id ?? '');
            preferencesHelper.setPhoneNumber(
                userPhoneNumber: event.contactNumber);
            Navigator.pushNamed(event.context, RouteDefine.otpScreen.name, arguments: {
              AppStrings.contactString: event.contactNumber,
              AppStrings.isRegisterString: state.isRegister
            });
            emit(state.copyWith(isLoginSuccess: true, isLoading: false));
          } else if(response.status == 403){
            print('here');
            CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(
                    response.message?.toLocalization() ??
                        response.message!,
                    event.context),
                type: SnackBarType.FAILURE);
            emit(state.copyWith(
              isLoading: false,
            ));
          }
          else {
            print('here 1');
            CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(
                    response.message?.toLocalization() ??
                        response.message!,
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
      }
      else if (event is _ChangeAuthEvent) {
        emit(state.copyWith(isRegister: event.isRegister));
      }
    });
  }
}