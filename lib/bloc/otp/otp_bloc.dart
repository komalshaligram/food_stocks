import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:food_stock/data/model/res_model/login_otp_res_model/login_otp_res_model.dart';
import 'package:food_stock/routes/app_routes.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_urls.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/req_model/login_req_model/login_req_model.dart';
import '../../data/model/req_model/otp_req_model/otp_req_model.dart';
import '../../data/model/res_model/login_res_model/login_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../ui/utils/themes/app_strings.dart';

part 'otp_event.dart';

part 'otp_state.dart';

part 'otp_bloc.freezed.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  late StreamSubscription _periodicOtpTimerSubscription;

  OtpBloc() : super(OtpState.initial()) {
    on<OtpEvent>((event, emit) async {
      SharedPreferencesHelper preferencesHelper =
      SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());

      if (event is _SetOtpTimerEvent) {
        if (state.otpTimer == 0 ) {
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
              preferencesHelper.setWalletId(
                  UserWalletId: response.data?.wallet ?? '');

              emit(state.copyWith(isLoading: false));
              Navigator.popUntil(event.context,
                  (route) => route.name == RouteDefine.connectScreen.name);
              Navigator.pushNamed(
                  event.context, RouteDefine.bottomNavScreen.name,
               /*   arguments: {
                    AppStrings.pushNavigationString : 'storeScreen'
                  }*/
              );
              CustomSnackBar.showSnackBar(
                  context: event.context,
                title: AppStrings.getLocalizedStrings(
                    response.message?.toLocalization() ??
                        response.message!,
                    event.context),
                  type: SnackBarType.SUCCESS,

              );
            }else if(response.status == 400){
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
            else {
              print('here');
              emit(state.copyWith(isLoading: false));
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title: AppStrings.getLocalizedStrings(
                      response.message?.toLocalization() ??
                          response.message!,
                      event.context),
                  type: SnackBarType.FAILURE);
            }
          } catch (e) {
            debugPrint('err = ${e}');
            emit(state.copyWith(isLoading: false));
          }
        } else {
          CustomSnackBar.showSnackBar(
              context: event.context,
              title: '${AppLocalizations.of(event.context)!.please_enter_otp}',
              type: SnackBarType.SUCCESS);
        }
      } else if (event is _ChangeOtpEvent) {
        emit(state.copyWith(otp: event.otp));
        debugPrint('new otp = ${state.otp}');
      }
      else if (event is _registerApiEvent) {
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
            );
            debugPrint('otp req = $reqMap');

            final res = await DioClient(event.context)
                .post(AppUrls.otpVerifyUrl, data: reqMap);
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
            /* preferencesHelper.setUserLoggedIn(isLoggedIn: true);*/
              preferencesHelper.setWalletId(
                  UserWalletId: response.data?.wallet ?? '');
              emit(state.copyWith(isLoading: false));
              Navigator.popUntil(event.context,
                  (route) => route.name == RouteDefine.connectScreen.name);
              Navigator.pushNamed(event.context, RouteDefine.profileScreen.name,
                  arguments: {AppStrings.contactString: event.contact});
            }else if(response.status == 400){
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
            else {
              emit(state.copyWith(isLoading: false));
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title: AppStrings.getLocalizedStrings(
                      response.message?.toLocalization() ??
                          response.message!,
                      event.context),
                  type: SnackBarType.FAILURE);
            }
          } catch (e) {
            debugPrint('err = ${e}');
            emit(state.copyWith(isLoading: false));
          }
        } else {
          CustomSnackBar.showSnackBar(
              context: event.context,
              title: '${AppLocalizations.of(event.context)!.please_enter_otp}',
              type: SnackBarType.SUCCESS);
        }
      }

      if (event is _logInApiDataEvent) {
        emit(state.copyWith(isLoading: false));
        try {
          LoginReqModel reqMap = LoginReqModel(
              contact: event.contactNumber, isRegistration: event.isRegister);
          debugPrint(
              'login req = ${reqMap.toJson()}');
          debugPrint('url3 = ${AppUrls.existingUserLoginUrl}');
          final res = await DioClient(event.context).post(
            AppUrls.existingUserLoginUrl,
            data: reqMap,
          );

          LoginResModel response = LoginResModel.fromJson(res);

            debugPrint('login response --- ${response}');

          if (response.status == 200) {
            await SmsAutoFill().listenForCode();
            CustomSnackBar.showSnackBar(
                context: event.context,
                title: '${AppLocalizations.of(event.context)!.otp_resend_success}',
                type: SnackBarType.SUCCESS);
            preferencesHelper.setUserId(id: response.user?.id ?? '');
            preferencesHelper.setPhoneNumber(
                userPhoneNumber: event.contactNumber);
            emit(state.copyWith(/*isLoginSuccess: true, */isLoading: false));
          } else if(response.status == 403){
            print('here 1');
            CustomSnackBar.showSnackBar(
                context: event.context,
                title: response.message??'',
                type: SnackBarType.FAILURE);
            emit(state.copyWith(
              isLoading: false,
            ));
          }else {
            debugPrint(response.message!.toLocalization());
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
    });
  }
}