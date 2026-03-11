import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smartlook/flutter_smartlook.dart';
import '../../data/model/res_model/login_otp_res_model/login_otp_res_model.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/constants/app_constants.dart';
import '../../ui/utils/constants/app_urls.dart';
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

import '../../ui/utils/constants/app_strings.dart';
import 'dart:io';
part 'otp_event.dart';

part 'otp_state.dart';

part 'otp_bloc.freezed.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  late StreamSubscription _periodicOtpTimerSubscription;

  OtpBloc() : super(OtpState.initial()) {
    on<OtpEvent>((event, emit) async {
      SharedPreferencesHelper preferences = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());

      if (event is _setOtpTimerEvent) {
        if (state.otpTimer == 0) {
          emit(state.copyWith(otpTimer: 30));
          _periodicOtpTimerSubscription = Stream.periodic(const Duration(seconds: 1), (x) => x).listen(
            (_) => add(const _UpdateTimerEvent()),
            onError: (error) => printData("otp timer error = $error"),
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
            OtpReqModel reqMap = OtpReqModel(contact: event.contact, otp: event.otp, tokenId: preferences.getFCMToken());

            final res = await DioClient(event.context).post(AppUrlEndPoints.loginOTPUrl, data: reqMap);

            LoginOtpResModel response = LoginOtpResModel.fromJson(res);
            if (response.status == AppConstants.code_200) {
              _periodicOtpTimerSubscription.cancel();
              preferences.setCartId(cartId: response.data?.cartId ?? '');
              preferences.setAuthToken(accToken: response.data?.authToken?.accessToken ?? '');
              preferences.setRefreshToken(refToken: response.data?.authToken?.refreshToken ?? '');
              preferences.setUserId(
                id: (response.data?.adminType == AppStrings.subUserString) ? response.data?.user?.createdBy ?? '' : response.data?.user?.id ?? '',
              );
              if (response.data?.adminType == AppStrings.subUserString) {
                preferences.setUserName(name: response.data?.user?.contactName ?? '');
              } else {
                preferences.setUserName(name: response.data?.user?.clientDetail?.ownerName ?? '');
              }

              preferences.setUserImageUrl(imageUrl: response.data?.user?.profileImage ?? '');
              preferences.setUserLoggedIn(isLoggedIn: true);
              preferences.setWalletId(userWalletId: response.data?.wallet ?? '');
              preferences.setIsSubUser(isSubUser: (response.data?.adminType == AppStrings.subUserString) ? true : false);
              preferences.setEmailId(userEmailId: response.data?.user?.email ?? '');
              preferences.setClubAgentId(club_agent_Id: response.data?.agentId ?? '');

              String? businessName = await Smartlook.instance.user.properties.getString(AppStrings.userBusinessName);
              String? phoneNumber = await Smartlook.instance.user.properties.getString(AppStrings.userPhoneNum);
              if (Platform.isAndroid) {
                if (businessName != '' || businessName != null) {
                  Smartlook.instance.user.properties.removeString(AppStrings.userBusinessName);
                }
                if (phoneNumber != '' || phoneNumber != null) {
                  Smartlook.instance.user.properties.removeString(AppStrings.userPhoneNum);
                }
                Smartlook.instance.user.properties.putString(AppStrings.userPhoneNum, value: response.data?.user?.phoneNumber);
                Smartlook.instance.user.properties.putString(AppStrings.userBusinessName, value: response.data?.user?.clientDetail?.bussinessName ?? '');
              } else {
                if (businessName == '' || businessName == null) {
                  Smartlook.instance.user.properties.putString(AppStrings.userBusinessName, value: response.data?.user?.clientDetail?.bussinessName ?? '');
                } else if (phoneNumber == '' || phoneNumber == null) {
                  Smartlook.instance.user.properties.putString(AppStrings.userPhoneNum, value: response.data?.user?.phoneNumber);
                }
              }

              Smartlook.instance.user.setIdentifier(
                (response.data?.adminType == AppStrings.subUserString) ? response.data?.user?.createdBy ?? '' : response.data?.user?.id ?? '',
              );
              Smartlook.instance.user.setEmail(response.data?.user?.phoneNumber ?? '');
              Smartlook.instance.user.setName(response.data?.user?.clientDetail?.ownerName ?? '');
              if (response.data?.adminType == AppStrings.subUserString) {
                var res = response.data?.subUserPermissions;
                preferences.setSubUserId(id: response.data?.user?.id ?? '');
                preferences.setCanSeeWallet(isSeeWallet: res?.canSeeWallet ?? false);
                preferences.setCanAddBasket(isAddBasket: res?.canAddToCart ?? false);
                preferences.setCanCreateOrder(isCreateOrder: res?.canCreateOrder ?? false);
                preferences.setCanSeeOrder(isSeeOrder: res?.canSeeOrders ?? false);
                preferences.setCanDuplicateOrder(isDuplicateOrder: res?.canDuplicateOrders ?? false);
                preferences.setCanUpdateBusinessInfo(isUpdateBusinessInfo: res?.canSeeAndUpdateBusinessInfo ?? false);
                preferences.setCanUpdateAdditionalInfo(isUpdateAdditionalInfo: res?.canSeeAndUpdateAdditionalInfo ?? false);
                preferences.setCanUpdateTimeInfo(isUpdateTimeInfo: res?.canSeeAndUpdateTimesInfo ?? false);
                preferences.setCanSeeFormsFiles(isSeeFormsFiles: res?.canSeeFileAndForms ?? false);
                preferences.setManageSubUser(isManageSubUser: res?.canManageSubUsers ?? false);
              }
              emit(state.copyWith(isLoading: false));

              Navigator.pushNamedAndRemoveUntil(event.context, RouteDefine.bottomNavScreen.name, (Route route) => route.isFirst);

              CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
                type: SnackBarType.success,
              );
            } else if (response.status == AppConstants.code_400) {
              CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
                type: SnackBarType.failure,
              );
              emit(state.copyWith(
                isLoading: false,
              ));
            } else {
              emit(state.copyWith(isLoading: false));
              CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
                type: SnackBarType.failure,
              );
            }
          } catch (e) {
            emit(state.copyWith(isLoading: false));
          }
        } else {
          CustomSnackBar.showSnackBar(context: event.context, title: AppLocalizations.of(event.context)!.please_enter_otp, type: SnackBarType.success);
        }
      } else if (event is _changeOtpEvent) {
        emit(state.copyWith(otp: event.otp));
      } else if (event is _registerApiEvent) {
        if (state.isLoading) {
          return;
        }
        if (event.otp.length == 4) {
          emit(state.copyWith(isLoading: true));
          try {
            OtpReqModel reqMap = OtpReqModel(
              contact: event.contact,
              otp: event.otp,
            );
            final res = await DioClient(event.context).post(AppUrlEndPoints.otpVerifyUrl, data: reqMap);
            LoginOtpResModel response = LoginOtpResModel.fromJson(res);

            if (response.status == AppConstants.code_200) {
              _periodicOtpTimerSubscription.cancel();
              preferences.setCartId(cartId: response.data?.cartId ?? '');
              preferences.setAuthToken(accToken: response.data?.authToken?.accessToken ?? '');
              preferences.setRefreshToken(refToken: response.data?.authToken?.refreshToken ?? '');
              preferences.setUserId(id: response.data?.user?.id ?? '');
              preferences.setWalletId(userWalletId: response.data?.wallet ?? '');
              emit(state.copyWith(isLoading: false));
              Navigator.popUntil(event.context, (route) => route.name == RouteDefine.connectScreen.name);
              Navigator.pushNamed(event.context, RouteDefine.profileScreen.name, arguments: {AppStrings.contactString: event.contact});
            } else if (response.status == AppConstants.code_400) {
              CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
                type: SnackBarType.failure,
              );
              emit(state.copyWith(
                isLoading: false,
              ));
            } else {
              emit(state.copyWith(isLoading: false));
              CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
                type: SnackBarType.failure,
              );
            }
          } catch (e) {
            emit(state.copyWith(isLoading: false));
          }
        } else {
          CustomSnackBar.showSnackBar(context: event.context, title: AppLocalizations.of(event.context)!.please_enter_otp, type: SnackBarType.success);
        }
      }

      if (event is _logInApiDataEvent) {
        emit(state.copyWith(isLoading: false));
        try {
          LoginReqModel reqMap = LoginReqModel(applicationName: AppStrings.appName, contact: event.contactNumber);

          final res = await DioClient(event.context).post(
            AppUrlEndPoints.existingUserLoginUrl,
            data: reqMap,
          );

          LoginResModel response = LoginResModel.fromJson(res);

          if (response.status == AppConstants.code_200) {
            await SmsAutoFill().listenForCode();
            CustomSnackBar.showSnackBar(context: event.context, title: AppLocalizations.of(event.context)!.otp_resend_success, type: SnackBarType.success);
            preferences.setUserId(id: response.user?.id ?? '');
            preferences.setPhoneNumber(userPhoneNumber: event.contactNumber);
            emit(state.copyWith(isLoading: false));
          } else if (response.status == AppConstants.code_403) {
            CustomSnackBar.showSnackBar(context: event.context, title: response.message ?? '', type: SnackBarType.failure);
            emit(state.copyWith(
              isLoading: false,
            ));
          } else {
            CustomSnackBar.showSnackBar(
              context: event.context,
              title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
              type: SnackBarType.failure,
            );
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
