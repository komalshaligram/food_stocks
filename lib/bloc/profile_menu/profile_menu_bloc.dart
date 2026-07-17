import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/res_model/login_otp_res_model/login_otp_res_model.dart';
import '../../data/model/res_model/status_info_res_model/status_info_res_model.dart';
import '../../repository/dio_client.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/constants/app_constants.dart';
import '../../ui/utils/constants/app_urls.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../../data/model/req_model/profile_details_req_model/profile_details_req_model.dart';
import '../../data/model/res_model/account_permission/account_permission_res_model.dart';
import '../../data/model/res_model/profile_details_res_model/profile_details_res_model.dart';
import '../../data/model/res_model/setting_res_model/setting_res_model.dart';
import '../../data/model/res_model/verify_client_res_model/verify_client_res_model.dart';
import '../../data/services/locale_provider.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/constants/app_strings.dart';
import 'package:food_stock/doc_scan/core/storage/documents_storage.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import '../bottom_nav/bottom_nav_bloc.dart';

part 'profile_menu_event.dart';
part 'profile_menu_state.dart';
part 'profile_menu_bloc.freezed.dart';

class ProfileMenuBloc extends Bloc<ProfileMenuEvent, ProfileMenuState> {
  ProfileMenuBloc() : super(ProfileMenuState.initial()) {
    on<ProfileMenuEvent>((event, emit) async {
      SharedPreferencesHelper preferences =
      SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
      if (preferences.getGuestUser()) {
      } else {
        if (event is _getPreferenceDataEvent) {
          PackageInfo packageInfo = await PackageInfo.fromPlatform();

          emit(state.copyWith(
            applicationVersion: packageInfo.version,
            buildNumber: packageInfo.buildNumber,
            userImageUrl: preferences.getUserImageUrl(),
            language: preferences.getAppLanguage(),
            isSubUserSeeOrder: preferences.getCanSeeOrder(),
            isSubUserCanManageSubUser: preferences.getCanManageSubUser(),
            isSubUserUpdateTimeInfo: preferences.getCanUpdateTimeInfo(),
            isSubUserSeeReturns: preferences.getCanSeeReturns(),
            isSubUserUpdateBusinessInfo: preferences.getCanUpdateBusinessInfo(),
            isSubUserUpdateAdditionalInfo:
            preferences.getCanUpdateAdditionalInfo(),
            isSubUserSeeFormsFiles: preferences.getCanSeeFormsFiles(),
            isCanSeeInvoices: preferences.getCanSeeInvoices(),
            isCanScanDocuments: preferences.getDocumentScanMenuVisible(),
            showDocumentScanOnApp: preferences.getDocumentScanOnApp(),
            userName: preferences.getBusinessName(),
            userCompanyLogoUrl: preferences.getUserCompanyLogoUrl(),
            clubAgentId: preferences.getClubAgentId(),
            isAgent: preferences.getIsAgent(),
            isAgentSwitchToAssignedStore:
            preferences.getIsAgentSwitchToAssignedStore(),
          ));
        } else if (event is _getAppLanguage) {
          String appLang = preferences.getAppLanguage();
          if (appLang == AppStrings.hebrewString) {
            emit(state.copyWith(isHebrewLanguage: true));
          }
        } else if (event is _logOutEvent) {
          emit(state.copyWith(isLogOutProcess: true));
          try {
            final response = await DioClient(event.context).put(
                path: AppUrlEndPoints.logOutUrl,
                data: {"userId": preferences.getUserId()});
            if (response[AppStrings.statusString] == AppConstants.code_200) {
              // נקה את מטמון המסמכים הסרוקים של הלקוח הנוכחי לפני יציאה (פרטיות + מניעת דליפה).
              await DocumentsStorage.clearForCurrentClient();
              await preferences.setUserLoggedIn();
              await Provider.of<LocaleProvider>(event.context, listen: false)
                  .setAppLocale(locale: const Locale(AppStrings.hebrewString));
              Navigator.pop(event.context);
              Navigator.popUntil(event.context,
                      (route) => route.name == RouteDefine.bottomNavScreen.name);
              Navigator.pushNamed(
                  event.context, RouteDefine.connectScreen.name);
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title: AppLocalizations.of(event.context)!
                      .logged_out_successfully,
                  type: SnackBarType.success);
              emit(state.copyWith(isLogOutProcess: false));
            } else {
              CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(
                    response[AppStrings.messageString]
                        .toString()
                        .toLocalization(),
                    event.context),
                type: SnackBarType.success,
              );
              emit(state.copyWith(isLogOutProcess: false));
            }
          } on ServerException {
            emit(state.copyWith(isLogOutProcess: false));
          }
        } else if (event is _changeAppLanguageEvent) {
          if (state.isHebrewLanguage) {
            emit(state.copyWith(isHebrewLanguage: false));
            await Provider.of<LocaleProvider>(event.context, listen: false)
                .setAppLocale(locale: const Locale(AppStrings.englishString));
          } else {
            emit(state.copyWith(isHebrewLanguage: true));
            await Provider.of<LocaleProvider>(event.context, listen: false)
                .setAppLocale(locale: const Locale(AppStrings.hebrewString));
          }
        } else if (event is _getProfileDetailsEvent) {
          try {
            final res = await DioClient(event.context).post(
                AppUrlEndPoints.getProfileDetailsUrl,
                data: ProfileDetailsReqModel(id: preferences.getUserId())
                    .toJson());
            ProfileDetailsResModel response =
            ProfileDetailsResModel.fromJson(res);
            if (response.status == AppConstants.code_200) {
              final clientData = response.data?.clients?.first;
              preferences.setDocumentScanOnApp(
                showDocumentScanOnApp:
                clientData?.clientDetail?.showDocumentScanOnApp ?? false,
              );
              if (!preferences.getSubUser()) {
                preferences.setUserImageUrl(
                    imageUrl: clientData?.profileImage ?? '');
                emit(state.copyWith(
                  userImageUrl: clientData?.profileImage ?? '',
                  showDocumentScanOnApp: preferences.getDocumentScanOnApp(),
                  isCanScanDocuments: preferences.getDocumentScanMenuVisible(),
                ));
              } else {
                emit(state.copyWith(
                  showDocumentScanOnApp: preferences.getDocumentScanOnApp(),
                  isCanScanDocuments: preferences.getDocumentScanMenuVisible(),
                ));
              }
            } else {
              CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(
                    response.message?.toLocalization() ?? response.message!,
                    event.context),
                type: SnackBarType.failure,
              );
            }
          } catch (_) {}
        } else if (event is _getPermissionList) {
          if (preferences.getSubUser()) {
            try {
              final res = await DioClient(event.context).get(
                  path:
                  '${AppUrlEndPoints.getAccountPermissionUrl}${preferences.getSubUserId()}');
              AccountPermissionResModel response =
              AccountPermissionResModel.fromJson(res);
              if (response.status == AppConstants.code_200) {
                var res = response.data?.permissions;
                if (preferences.getCanSeeWallet() != res?.canSeeWallet) {
                  event.context.read<BottomNavBloc>().add(
                      BottomNavEvent.changePage(
                          index: preferences.getCanSeeWallet() ? 4 : 3,
                          context: event.context));
                }
                preferences.setCanSeeWallet(
                    isSeeWallet: res?.canSeeWallet ?? false);
                emit(state.copyWith(isAccountPermissionShimmering: true));
                preferences.setCanAddBasket(
                    isAddBasket: res?.canAddToCart ?? false);
                preferences.setCanCreateOrder(
                    isCreateOrder: res?.canCreateOrder ?? false);
                preferences.setCanSeeOrder(
                    isSeeOrder: res?.canSeeOrders ?? false);
                preferences.setCanDuplicateOrder(
                    isDuplicateOrder: res?.canDuplicateOrders ?? false);
                preferences.setCanUpdateBusinessInfo(
                    isUpdateBusinessInfo:
                    res?.canSeeAndUpdateBusinessInfo ?? false);
                preferences.setCanUpdateAdditionalInfo(
                    isUpdateAdditionalInfo:
                    res?.canSeeAndUpdateAdditionalInfo ?? false);
                preferences.setCanUpdateTimeInfo(
                    isUpdateTimeInfo: res?.canSeeAndUpdateTimesInfo ?? false);
                preferences.setCanSeeFormsFiles(
                    isSeeFormsFiles: res?.canSeeFileAndForms ?? false);
                preferences.setManageSubUser(
                    isManageSubUser: res?.canManageSubUsers ?? false);
                preferences.setCanSeeInvoices(
                    isCanSeeInvoices: res?.canSeeInvoices ?? false);
                preferences.setCanSeeReturns(
                    isCanSeeReturns: res?.returns ?? false);
                preferences.setCanScanDocuments(
                    isCanScanDocuments: res?.canScanDocuments ?? false);
                emit(state.copyWith(
                  isSubUserSeeOrder: preferences.getCanSeeOrder(),
                  isSubUserCanManageSubUser: preferences.getCanManageSubUser(),
                  isSubUserUpdateTimeInfo: preferences.getCanUpdateTimeInfo(),
                  isSubUserUpdateBusinessInfo:
                  preferences.getCanUpdateBusinessInfo(),
                  isSubUserUpdateAdditionalInfo:
                  preferences.getCanUpdateAdditionalInfo(),
                  isSubUserSeeReturns: preferences.getCanSeeReturns(),
                  isSubUserSeeFormsFiles: preferences.getCanSeeFormsFiles(),
                  isAccountPermissionShimmering: false,
                  isCanSeeInvoices: preferences.getCanSeeInvoices(),
                  isCanScanDocuments: preferences.getDocumentScanMenuVisible(),
                  showDocumentScanOnApp: preferences.getDocumentScanOnApp(),
                ));
              } else {
                CustomSnackBar.showSnackBar(
                  context: event.context,
                  title: AppStrings.getLocalizedStrings(
                      response.message?.toLocalization() ?? response.message!,
                      event.context),
                  type: SnackBarType.failure,
                );
              }
            } catch (e) {
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title: e.toString(),
                  type: SnackBarType.failure);
            }
          }
        } else if (event is _updateMaintenanceEvent) {
          emit(state.copyWith(isDialogOpen: true));
        } else if (event is _getStatusInfoEvent) {
          try {
            final res = await DioClient(event.context)
                .get(path: AppUrlEndPoints.getStatusInfoUrl);
            StatusInfoResModel response = StatusInfoResModel.fromJson(res);
            if (response.status == AppConstants.code_200) {
              String encodedStatus = json.encode(response.data?.status);
              preferences.setStatusInfo(statusData: encodedStatus);
              String encodedReturnStatus =
              json.encode(response.data?.returnStatus);
              preferences.setReturnStatusInfo(statusData: encodedReturnStatus);
              String encodedPaymentStatus =
              json.encode(response.data?.paymentStatus);
              preferences.setPaymentStatusInfo(
                  statusData: encodedPaymentStatus);
              String encodedOrderStatus =
              json.encode(response.data?.orderStatus);
              preferences.setOrderStatusInfo(statusData: encodedOrderStatus);
            }
          } catch (e) {
            CustomSnackBar.showSnackBar(
                context: event.context,
                title: e.toString(),
                type: SnackBarType.failure);
          }
        } else if (event is _generalSettings) {
          try {
            emit(state.copyWith(retryLoading: event.isRetryLoading));
            final res = await DioClient(event.context)
                .get(path: AppUrlEndPoints.generalSettingUrl);
            SettingResModel response = SettingResModel.fromJson(res);
            if (response.status == AppConstants.code_200) {
              preferences.setBankTransferDetail(
                  details: response
                      .data?.taviliRivchitDetails?.bankTransferInfoText ??
                      '');
              if (preferences.getAppOnMaintenance() &&
                  !(response.data?.isAppOnMaintenance ?? false)) {
                add(ProfileMenuEvent.updateMaintenanceEvent(
                    context: event.context));
                Navigator.pop(event.dialogContext);
                preferences.setIsAppOnMaintenance(isAppOnMaintenance: false);
                emit(state.copyWith(
                    isDialogOpen: false,
                    isAppOnMaintenance: false,
                    retryLoading: false));
                return;
              } else {
                if (!state.isDialogOpen &&
                    !(response.data?.isAppOnMaintenance ?? false)) {
                  emit(state.copyWith(isDialogOpen: true));
                } else {
                  emit(state.copyWith(isDialogOpen: false));
                }
              }
              preferences.setIsSaleOn(
                  isSaleOn: response.data?.isSaleOn ?? false);
              preferences.setIsIncludedVat(
                  isIncludedVat: (response.data?.showVatApplication
                      ?.contains(AppStrings.appName) ??
                      false)
                      ? true
                      : false);
              preferences.setBottleTax(
                  bottleDeposit: response.data?.bottlePrice ?? 0.0);
              preferences.setIsAppOnMaintenance(
                  isAppOnMaintenance:
                  response.data?.isAppOnMaintenance ?? false);
              emit(state.copyWith(
                language: preferences.getAppLanguage(),
                bottlePrice: response.data?.bottlePrice ?? 0.0,
                isIncludedVat: preferences.getIsIncludedVat(),
                isSaleOn: preferences.getShowSale(),
                retryLoading: false,
                isAppOnMaintenance: preferences.getAppOnMaintenance(),
                customerServicePhone: response.data?.customerServicePhone ?? '',
                customerServiceWhatsApp:
                response.data?.customerServiceWhatsApp ?? '',
              ));
            }
          } catch (e) {
            CustomSnackBar.showSnackBar(
                context: event.context,
                title: e.toString(),
                type: SnackBarType.failure);
          }
        } else if (event is _userApproveEvent) {
          try {
            final res = await DioClient(event.context).post(
                AppUrlEndPoints.verifyClientUrl,
                data: {AppStrings.clientIdString: preferences.getUserId()});
            VerifyClientResModel response = VerifyClientResModel.fromJson(res);
            if (response.status == AppConstants.code_200) {
              if (!(response.data?.isFilledForms ?? false) ||
                  !(response.data?.isRegisterForm ?? false)) {
                Navigator.pushNamed(
                    event.context, RouteDefine.formDataScreen.name);
              } else if (!(response.data?.isUploadedFiles ?? false) &&
                  (response.data?.isRegisterForm ?? false) &&
                  (response.data?.isFilledForms ?? false)) {
                Navigator.pushNamed(
                    event.context, RouteDefine.fileUploadScreen.name);
              }
            }
          } catch (_) {}
        } else if (event is _switchAccountEvent) {
          emit(state.copyWith(isLoading: true));
          try {
            var reqMap = {'isStore': false};
            final res = await DioClient(event.context).post(
                AppUrlEndPoints.agentSwitchToAssignedStore +
                    preferences.getUserId(),
                data: reqMap);
            LoginOtpResModel response = LoginOtpResModel.fromJson(res);
            if (response.status == AppConstants.code_200) {
              preferences.setCartId(cartId: response.data?.cartId ?? '');
              preferences.setAuthToken(
                  accToken: response.data?.authToken?.accessToken ?? '');
              preferences.setRefreshToken(
                  refToken: response.data?.authToken?.refreshToken ?? '');
              preferences.setUserId(
                  id: (response.data?.adminType == AppStrings.subUserString)
                      ? response.data?.user?.createdBy ?? ''
                      : response.data?.user?.id ?? '');
              if (response.data?.adminType == AppStrings.subUserString) {
                preferences.setUserName(
                    name: response.data?.user?.contactName ?? '');
              } else {
                preferences.setUserName(
                    name: response.data?.user?.clientDetail?.ownerName ?? '');
              }
              preferences.setUserImageUrl(
                  imageUrl: response.data?.user?.profileImage ?? '');
              preferences.setUserLoggedIn(isLoggedIn: true);
              preferences.setWalletId(
                  userWalletId: response.data?.wallet ?? '');
              preferences.setIsSubUser(
                  isSubUser:
                  (response.data?.adminType == AppStrings.subUserString)
                      ? true
                      : false);
              preferences.setEmailId(
                  userEmailId: response.data?.user?.email ?? '');
              preferences.setClubAgentId(
                  clubAgentId: response.data?.agentId ?? '');
              preferences.setIsAgent(isAgent: response.data?.isAgent ?? false);
              preferences.setIsAgentSwitchToAssignedStore(
                  isAgentSwitchToAssignedStore:
                  response.data?.isAgentSwitchToAssignedStore ?? false);
              if (response.data?.adminType == AppStrings.subUserString) {
                var res = response.data?.subUserPermissions;
                preferences.setSubUserId(id: response.data?.user?.id ?? '');
                preferences.setCanSeeWallet(
                    isSeeWallet: res?.canSeeWallet ?? false);
                preferences.setCanAddBasket(
                    isAddBasket: res?.canAddToCart ?? false);
                preferences.setCanCreateOrder(
                    isCreateOrder: res?.canCreateOrder ?? false);
                preferences.setCanSeeOrder(
                    isSeeOrder: res?.canSeeOrders ?? false);
                preferences.setCanDuplicateOrder(
                    isDuplicateOrder: res?.canDuplicateOrders ?? false);
                preferences.setCanUpdateBusinessInfo(
                    isUpdateBusinessInfo:
                    res?.canSeeAndUpdateBusinessInfo ?? false);
                preferences.setCanUpdateAdditionalInfo(
                    isUpdateAdditionalInfo:
                    res?.canSeeAndUpdateAdditionalInfo ?? false);
                preferences.setCanUpdateTimeInfo(
                    isUpdateTimeInfo: res?.canSeeAndUpdateTimesInfo ?? false);
                preferences.setCanSeeFormsFiles(
                    isSeeFormsFiles: res?.canSeeFileAndForms ?? false);
                preferences.setManageSubUser(
                    isManageSubUser: res?.canManageSubUsers ?? false);
                preferences.setCanScanDocuments(
                    isCanScanDocuments: res?.canScanDocuments ?? false);
              }
              emit(state.copyWith(isLoading: false));
              Navigator.pushNamedAndRemoveUntil(
                  event.context,
                  RouteDefine.bottomNavScreen.name,
                      (Route route) => route.isFirst);
              CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(
                    AppLocalizations.of(event.context)!.switch_agent_message,
                    event.context),
                type: SnackBarType.success,
              );
            } else if (response.status == AppConstants.code_400) {
              CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(
                    response.message?.toLocalization() ?? response.message!,
                    event.context),
                type: SnackBarType.failure,
              );
              emit(state.copyWith(isShimmering: false));
            } else {
              emit(state.copyWith(isShimmering: false));
              CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(
                    response.message?.toLocalization() ?? response.message!,
                    event.context),
                type: SnackBarType.failure,
              );
            }
          } catch (_) {}
        }
      }
    });
  }
}
