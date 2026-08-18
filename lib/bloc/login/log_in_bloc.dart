import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/constants/app_constants.dart';
import '../../ui/utils/constants/app_urls.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
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
  StreamSubscription? _cooldownTicker;

  @override
  Future<void> close() {
    _cooldownTicker?.cancel();
    return super.close();
  }

  LogInBloc() : super(LogInState.initial()) {
    on<LogInEvent>((event, emit) async {
      if (state.isLoading) {
        return;
      }
      SharedPreferencesHelper preferences = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());

      if (event is _syncCooldownEvent) {
        final int remaining = preferences.getOtpCooldownRemaining(event.contactNumber);
        emit(state.copyWith(otpCooldown: remaining));
        _cooldownTicker?.cancel();
        if (remaining > 0) {
          _cooldownTicker =
              Stream.periodic(const Duration(seconds: 1), (x) => x).listen((_) => add(LogInEvent.syncCooldown(contactNumber: event.contactNumber)));
        }
        return;
      }

      if (event is _logInApiDataEvent) {
        if (preferences.getOtpCooldownRemaining(event.contactNumber) > 0) {
          add(LogInEvent.syncCooldown(contactNumber: event.contactNumber));
          return;
        }
        emit(state.copyWith(isLoading: true));
        preferences.setIsGuestUser(isGuestUser: false);
        try {
          LoginReqModel reqMap = LoginReqModel(contact: event.contactNumber, applicationName: AppStrings.appName);
          final res = await DioClient(event.context).post(AppUrlEndPoints.existingUserLoginUrl, data: reqMap);
          LoginResModel response = LoginResModel.fromJson(res);
          if (response.status == AppConstants.code_200) {
            await SmsAutoFill().listenForCode();
            preferences.setIsGuestUser(isGuestUser: false);
            if (response.user != null) {
              preferences.setUserId(id: response.user?.id ?? '');
              preferences.setPhoneNumber(userPhoneNumber: event.contactNumber);
            }

            final int nextCount = preferences.getOtpSendCount(event.contactNumber) + 1;
            await preferences.setOtpCooldown(contact: event.contactNumber, seconds: otpCooldownSeconds(nextCount), sendCount: nextCount);

            Navigator.pushNamed(event.context, RouteDefine.otpScreen.name, arguments: {
              AppStrings.contactString: event.contactNumber,
              AppStrings.isRegisterString: !(response.data?.isUserExists ?? false),
            }).then((_) => add(LogInEvent.syncCooldown(contactNumber: event.contactNumber)));
            emit(state.copyWith(isLoading: false));

            add(LogInEvent.syncCooldown(contactNumber: event.contactNumber));
          } else if (response.status == AppConstants.code_403) {
            CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
                type: SnackBarType.failure);
            emit(state.copyWith(isLoading: false));
          } else {
            CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
                type: SnackBarType.failure);
            emit(state.copyWith(isLoading: false));
          }
        } on ServerException {
          emit(state.copyWith(isLoading: false));
        } catch (e) {
          emit(state.copyWith(isLoading: false));
        }
      } else if (event is _checkVersionOfAppEvent) {
        scheduleScreenUpdateCheck(event.context);
      } else if (event is _changeAuthEvent) {
        emit(state.copyWith(isRegister: event.isRegister));
      }
    });
  }
}
