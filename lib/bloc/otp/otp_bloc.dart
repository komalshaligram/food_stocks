import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
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
import '../../data/model/res_model/setting_res_model/setting_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../ui/widget/dialogs/otp_whatsapp_sent_dialog.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import '../../ui/utils/constants/app_strings.dart';
part 'otp_event.dart';
part 'otp_state.dart';
part 'otp_bloc.freezed.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  StreamSubscription? _periodicOtpTimerSubscription;

  OtpBloc() : super(OtpState.initial()) {
    on<OtpEvent>((event, emit) async {
      SharedPreferencesHelper preferences = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());

      if (event is _setOtpTimerEvent) {

        final int remaining = preferences.getOtpCooldownRemaining(event.contact);
        emit(state.copyWith(
          otpTimer: remaining,
          sendCount: preferences.getOtpSendCount(event.contact),
        ));
        _periodicOtpTimerSubscription?.cancel();
        if (remaining > 0) {
          _periodicOtpTimerSubscription = Stream.periodic(const Duration(seconds: 1), (x) => x).listen(
                (_) => add(const _UpdateTimerEvent()),
            onError: (error) => printData("otp timer error = $error"),
          );
        }
      } else if (event is _UpdateTimerEvent) {
        if (state.otpTimer == 0) {
          _periodicOtpTimerSubscription?.cancel();
        } else {
          emit(state.copyWith(otpTimer: state.otpTimer - 1));
        }
      } else if (event is _cancelTimerscriptionEvent) {
        _periodicOtpTimerSubscription?.cancel();
      }

      if (event is _otpApiEvent) {
        if (state.isLoading) {
          return;
        }
        if (event.otp.length == 4) {
          emit(state.copyWith(isLoading: true));
          try {
            OtpReqModel reqMap = OtpReqModel(contact: event.contact, otp: event.otp, tokenId: preferences.getFCMToken(), applicationName: 'Tavili');
            final res = await DioClient(event.context).post(AppUrlEndPoints.loginOTPUrl, data: reqMap);
            LoginOtpResModel response = LoginOtpResModel.fromJson(res);
            if (response.status == AppConstants.code_200) {
              _periodicOtpTimerSubscription?.cancel();
              preferences.clearOtpCooldown();
              preferences.setCartId(cartId: response.data?.cartId ?? '');
              preferences.setAuthToken(accToken: response.data?.authToken?.accessToken ?? '');
              preferences.setRefreshToken(refToken: response.data?.authToken?.refreshToken ?? '');
              preferences.setUserId(id: (response.data?.adminType == AppStrings.subUserString) ? response.data?.user?.createdBy ?? '' : response.data?.user?.id ?? '');
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
              preferences.setClubAgentId(clubAgentId: response.data?.agentId ?? '');
              preferences.setIsAgent(isAgent: response.data?.isAgent ?? false);
              preferences.setIsAgentSwitchToAssignedStore(isAgentSwitchToAssignedStore: response.data?.isAgentSwitchToAssignedStore ?? false);
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
                preferences.setCanScanDocuments(isCanScanDocuments: res?.canScanDocuments ?? false);
              }
              emit(state.copyWith(isLoading: false));
              final bool isRegistrationComplete = (res['data'] is Map) ? (res['data']['isRegistrationComplete'] ?? true) : true;
              preferences.setRegistrationIncomplete(isIncomplete: !isRegistrationComplete);
              if (isRegistrationComplete) {
                Navigator.pushNamedAndRemoveUntil(event.context, RouteDefine.bottomNavScreen.name, (Route route) => route.isFirst);
              } else {
                Navigator.pushNamedAndRemoveUntil(
                  event.context,
                  RouteDefine.profileScreen.name,
                      (Route route) => route.isFirst,
                  arguments: {AppStrings.contactString: event.contact},
                );
              }

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
              emit(state.copyWith(isLoading: false));
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
            OtpReqModel reqMap = OtpReqModel(contact: event.contact, otp: event.otp);
            final res = await DioClient(event.context).post(AppUrlEndPoints.otpVerifyUrl, data: reqMap);
            LoginOtpResModel response = LoginOtpResModel.fromJson(res);
            if (response.status == AppConstants.code_200) {
              _periodicOtpTimerSubscription?.cancel();
              preferences.clearOtpCooldown();
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
              emit(state.copyWith(isLoading: false));
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
          final res = await DioClient(event.context).post(AppUrlEndPoints.existingUserLoginUrl, data: reqMap);
          LoginResModel response = LoginResModel.fromJson(res);
          if (response.status == AppConstants.code_200) {
            await SmsAutoFill().listenForCode();
            CustomSnackBar.showSnackBar(context: event.context, title: AppLocalizations.of(event.context)!.otp_resend_success, type: SnackBarType.success);
            preferences.setUserId(id: response.user?.id ?? '');
            preferences.setPhoneNumber(userPhoneNumber: event.contactNumber);

            final int nextCount = preferences.getOtpSendCount(event.contactNumber) + 1;
            await preferences.setOtpCooldown(
              contact: event.contactNumber,
              seconds: otpCooldownSeconds(nextCount),
              sendCount: nextCount,
            );
            emit(state.copyWith(isLoading: false));
            add(OtpEvent.setOtpTimer(contact: event.contactNumber));
          } else if (response.status == AppConstants.code_403) {
            CustomSnackBar.showSnackBar(context: event.context, title: response.message ?? '', type: SnackBarType.failure);
            emit(state.copyWith(isLoading: false));
          } else {
            CustomSnackBar.showSnackBar(
              context: event.context,
              title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
              type: SnackBarType.failure,
            );
            emit(state.copyWith(isLoading: false));
          }
        } on ServerException {
          emit(state.copyWith(isLoading: false));
        } catch (e) {
          emit(state.copyWith(isLoading: false));
        }
      }

      if (event is _sendOtpViaWhatsappEvent) {
        if (state.isWhatsappSending) {
          return;
        }
        emit(state.copyWith(isWhatsappSending: true));
        try {

          final res = await DioClient(event.context).post(
            AppUrlEndPoints.sendOtpByWhatsappUrl,
            data: {
              AppStrings.contactString: event.contactNumber,
              'applicationName': AppStrings.appName,
              'forceNewOtp': preferences.getOtpSendCount(event.contactNumber) >= 2,
            },
          );

          final int? status = res[AppStrings.statusString] as int?;
          final String message = (res[AppStrings.messageString] ?? '').toString();
          if (status == AppConstants.code_200) {
            final int nextCount = preferences.getOtpSendCount(event.contactNumber) + 1;
            printData('whatsapp otp sent, restarting cooldown (send #$nextCount)');
            await preferences.setOtpCooldown(
              contact: event.contactNumber,
              seconds: otpCooldownSeconds(nextCount),
              sendCount: nextCount,
            );
            emit(state.copyWith(isWhatsappSending: false));
            add(OtpEvent.setOtpTimer(contact: event.contactNumber));
            if (event.context.mounted) {
              showOtpSentViaWhatsappDialog(context: event.context, contact: event.contactNumber);
            }
          } else {
            emit(state.copyWith(isWhatsappSending: false));
            CustomSnackBar.showSnackBar(
              context: event.context,
              title: AppStrings.getLocalizedStrings(message.toLocalization(), event.context),
              type: SnackBarType.failure,
            );
          }
        } on ServerException {
          emit(state.copyWith(isWhatsappSending: false));
        } catch (e) {
          emit(state.copyWith(isWhatsappSending: false));
        }
      } else if (event is _loadWhatsappOtpSettingEvent) {

        try {
          final res = await DioClient(event.context).get(path: AppUrlEndPoints.generalSettingUrl);
          SettingResModel response = SettingResModel.fromJson(res);
          if (response.status == AppConstants.code_200) {
            emit(state.copyWith(showWhatsappOtpOption: response.data?.showWhatsappOtpOption ?? false));
          }
        }  catch (e) {
          printData('whatsapp otp setting fetch failed = $e');
        }
      }
    });
  }
}