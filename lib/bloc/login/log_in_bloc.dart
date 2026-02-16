import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/constants/app_constants.dart';
import '../../ui/utils/constants/app_urls.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:store_version_checker/store_version_checker.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/req_model/login_req_model/login_req_model.dart';
import '../../data/model/res_model/login_res_model/login_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/constants/app_strings.dart';

part 'log_in_event.dart';

part 'log_in_state.dart';

part 'log_in_bloc.freezed.dart';

class LogInBloc extends Bloc<LogInEvent, LogInState> {
  LogInBloc() : super(LogInState.initial()) {
    on<LogInEvent>((event, emit) async {
      if (state.isLoading) {
        return;
      }
      SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());

      if (event is _logInApiDataEvent) {
        emit(state.copyWith(isLoading: true));
        preferencesHelper.setIsGuestUser(isGuestUser: false);
        try {
          LoginReqModel reqMap = LoginReqModel(contact: event.contactNumber, applicationName: AppStrings.appName);
          final res = await DioClient(event.context).post(
            AppUrlEndPoints.existingUserLoginUrl,
            data: reqMap,
          );

          LoginResModel response = LoginResModel.fromJson(res);

          if (response.status == AppConstants.code_200) {
            await SmsAutoFill().listenForCode();
            preferencesHelper.setIsGuestUser(isGuestUser: false);
            if (response.user != null) {
              preferencesHelper.setUserId(id: response.user?.id ?? '');
              preferencesHelper.setPhoneNumber(userPhoneNumber: event.contactNumber);
            }
            Navigator.pushNamed(event.context, RouteDefine.otpScreen.name, arguments: {AppStrings.contactString: event.contactNumber, AppStrings.isRegisterString: !(response.data?.isUserExists ?? false)});
            emit(state.copyWith(isLoading: false));
          } else if (response.status == AppConstants.code_403) {
            CustomSnackBar.showSnackBar(context: event.context, title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context), type: SnackBarType.failure);
            emit(state.copyWith(
              isLoading: false,
            ));
          } else {
            CustomSnackBar.showSnackBar(context: event.context, title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context), type: SnackBarType.failure);
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
      } else if (event is _checkVersionOfAppEvent) {
        final checker = StoreVersionChecker();
        checker.checkUpdate().then((value) {
          printData(value.currentVersion);
          printData(value.newVersion);
          printData(value.appURL);
          printData(value.errorMessage);
          if (value.canUpdate && Platform.isAndroid) {
            customShowUpdateDialog(event.context, preferencesHelper.getAppLanguage(), value.appURL ?? 'https://play.google.com/store/apps/details?id=com.foodstock.dev');
          } else if (value.canUpdate && Platform.isIOS) {
            customShowUpdateDialog(event.context, preferencesHelper.getAppLanguage(), value.appURL ?? 'https://apps.apple.com/ua/app/tavili/id6468264054');
          }
        });
      } else if (event is _changeAuthEvent) {
        emit(state.copyWith(isRegister: event.isRegister));
      }
    });
  }
}
