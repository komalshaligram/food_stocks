import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:food_stock/data/model/res_model/login_otp_res_model/login_otp_res_model.dart';
import 'package:food_stock/ui/utils/themes/app_urls.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/otp_req_model/otp_req_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';

part 'otp_event.dart';

part 'otp_state.dart';

part 'otp_bloc.freezed.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  late StreamSubscription _periodicOtpTimerSubscription;

  OtpBloc() : super(OtpState.initial()) {
    on<OtpEvent>((event, emit) async {
      if (event is _SetOtpTimerEvent) {
        if (state.otpTimer == 0) {
          emit(state.copyWith(otpTimer: 30));
          _periodicOtpTimerSubscription =
              Stream.periodic(const Duration(seconds: 1), (x) => x).listen(
            (_) => add(_UpdateTimerEvent()),
            onError: (error) => debugPrint("otp timer error = $error"),
          );
        }
      } else if (event is _UpdateTimerEvent) {
        if (state.otpTimer == 0) {
          _periodicOtpTimerSubscription.cancel();
        } else {
          emit(state.copyWith(otpTimer: state.otpTimer - 1));
        }
      } else if (event is _cancelTimerscriptionEvent) {
        _periodicOtpTimerSubscription.cancel();
      }

      if (event is _otpApiEvent) {
        if (event.otp.isNotEmpty) {
          emit(state.copyWith(isLoading: true));
          try {
            OtpReqModel reqMap =
                OtpReqModel(contact: event.contact, otp: event.otp);
            final res =
                await DioClient().post(AppUrls.loginOTPUrl, data: reqMap);
            debugPrint('otp response + $res');
            LoginOtpResModel response = LoginOtpResModel.fromJson(res);

            if (response.status == 200) {
              _periodicOtpTimerSubscription.cancel();
              SharedPreferencesHelper preferencesHelper =
                  SharedPreferencesHelper(
                      prefs: await SharedPreferences.getInstance());
              preferencesHelper.setAuthToken(
                  accToken: response.authToken?.accessToken ?? '');
              preferencesHelper.setRefreshToken(
                  refToken: response.authToken?.refreshToken ?? '');
              preferencesHelper.setUserId(id: response.data?.id ?? '');
              preferencesHelper.setUserName(
                  name: response.data?.clientDetail?.ownerName ?? '');
              // preferencesHelper.setUserImageUrl(imageUrl: '');
              // preferencesHelper.setUserCompanyLogoUrl(logoUrl: '');
              preferencesHelper.setUserLoggedIn(isLoggedIn: true);
              emit(state.copyWith(isLoginSuccess: true, isLoading: false));
              // debugPrint('________${preferencesHelper.getAuthToken()}');
              // debugPrint('________${preferencesHelper.getRefreshToken()}');
            } else {
              emit(state.copyWith(
                  isLoginFail: true, errorMessage: res['message']));
              emit(state.copyWith(isLoginFail: false, isLoading: false));
            }
          } catch (e) {
            emit(state.copyWith(isLoginFail: true, errorMessage: e.toString()));
            emit(state.copyWith(isLoginFail: false, isLoading: false));
          }
        } else {
          emit(state.copyWith(isLoginFail: true, errorMessage: 'enter otp'));
          emit(state.copyWith(isLoginFail: false));
        }
      }
    });
  }
}
