import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:food_stock/data/model/res_model/login_otp_res_model/login_otp_res_model.dart';
import 'package:food_stock/routes/app_routes.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_urls.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/model/req_model/otp_req_model/otp_req_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/themes/app_strings.dart';

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
        if (state.isLoading) {
          return;
        }
        if (event.otp.length == 4) {
          emit(state.copyWith(isLoading: true));
          try {
            SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(
                prefs: await SharedPreferences.getInstance());
            OtpReqModel reqMap = OtpReqModel(
                contact: event.contact,
                otp: event.otp,
                tokenId: preferencesHelper.getFCMToken());
            debugPrint('otp req = $reqMap');
            final res = await DioClient(event.context)
                .post(AppUrls.loginOTPUrl, data: reqMap);
            debugPrint('otp res = $res');
            LoginOtpResModel response = LoginOtpResModel.fromJson(res);

            if (response.status == 200) {
              _periodicOtpTimerSubscription.cancel();
              preferencesHelper.setCartId(cartId: response.data?.cartId ?? '');
              preferencesHelper.setAuthToken(
                  accToken: response.data?.authToken?.accessToken ?? '');
              preferencesHelper.setRefreshToken(
                  refToken: response.data?.authToken?.refreshToken ?? '');
              preferencesHelper.setUserId(id: response.data?.user?.id ?? '');
              preferencesHelper.setUserName(
                  name: response.data?.user?.clientDetail?.ownerName ?? '');
              preferencesHelper.setUserImageUrl(
                  imageUrl: response.data?.user?.profileImage ?? '');
              preferencesHelper.setUserCompanyLogoUrl(
                  logoUrl: response.data?.user?.logo ?? '');
              preferencesHelper.setUserLoggedIn(isLoggedIn: true);
              preferencesHelper.setWalletId(UserWalletId: response.data?.wallet ?? '');
              showSnackBar(
                  context: event.context,
                  title: response.message ?? AppStrings.loginSuccessString,
                  bgColor: AppColors.mainColor);
              Navigator.popUntil(event.context,
                      (route) => route.name == RouteDefine.connectScreen.name);
              Navigator.pushNamed(
                  event.context, RouteDefine.bottomNavScreen.name);
              emit(state.copyWith(isLoading: false));
            } else {
              emit(state.copyWith(isLoading: false));
              showSnackBar(
                  context: event.context,
                  title: response.message ?? AppStrings.somethingWrongString,
                  bgColor: AppColors.redColor);
            }
          } catch (e) {
            emit(state.copyWith(isLoading: false));
          }
        } else {
          showSnackBar(
              context: event.context,
              title: AppStrings.enterOtpString,
              bgColor: AppColors.mainColor);
        }
      } else if (event is _ChangeOtpEvent) {
        emit(state.copyWith(otp: event.otp));
        debugPrint('new otp = ${state.otp}');
      }
    });
  }
}
