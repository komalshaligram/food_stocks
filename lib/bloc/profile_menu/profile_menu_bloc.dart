import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:food_stock/data/error/exceptions.dart';
import 'package:food_stock/repository/dio_client.dart';
import 'package:food_stock/routes/app_routes.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_urls.dart';
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
import '../../ui/utils/themes/app_strings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../bottom_nav/bottom_nav_bloc.dart';

part 'profile_menu_event.dart';

part 'profile_menu_state.dart';

part 'profile_menu_bloc.freezed.dart';

class ProfileMenuBloc extends Bloc<ProfileMenuEvent, ProfileMenuState> {
  ProfileMenuBloc() : super(ProfileMenuState.initial()) {
    on<ProfileMenuEvent>((event, emit) async {
      SharedPreferencesHelper preferences = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
      if (preferences.getGuestUser()) {
      } else {
        if (event is _getPreferenceDataEvent) {
          PackageInfo packageInfo = await PackageInfo.fromPlatform();
          emit(state.copyWith(applicationVersion: packageInfo.version, buildNumber: packageInfo.buildNumber));

          emit(state.copyWith(UserImageUrl: preferences.getUserImageUrl(), language: preferences.getAppLanguage(), isSubUserSeeOrder: preferences.getCanSeeOrder(), isSubUserCanManageSubUser: preferences.getCanManageSubUser(), isSubUserUpdateTimeInfo: preferences.getCanUpdateTimeInfo(), isSubUserUpdateBusinessInfo: preferences.getCanUpdateBusinessInfo(), isSubUserUpdateAdditionalInfo: preferences.getCanUpdateAdditionalInfo(), isSubUserSeeFormsFiles: preferences.getCanSeeFormsFiles(), isCanSeeInvoices: preferences.getCanSeeInvoices()));
          emit(state.copyWith(UserCompanyLogoUrl: preferences.getUserCompanyLogoUrl()));
          emit(state.copyWith(userName: preferences.getUserName()));
        } else if (event is _getAppLanguage) {
          SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
          String appLang = preferencesHelper.getAppLanguage();
          if (appLang == AppStrings.hebrewString) {
            emit(state.copyWith(isHebrewLanguage: true));
          }
        } else if (event is _logOutEvent) {
          emit(state.copyWith(isLogOutProcess: true));
          try {
            final response = await DioClient(event.context).put(path: AppUrls.logOutUrl, data: {"userId": preferences.getUserId()});

            if (response[AppStrings.statusString] == AppConstants.code_200) {
              SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
              await preferencesHelper.setUserLoggedIn();
              await Provider.of<LocaleProvider>(event.context, listen: false).setAppLocale(locale: const Locale(AppStrings.hebrewString));
              Navigator.pop(event.context);
              Navigator.popUntil(event.context, (route) => route.name == RouteDefine.bottomNavScreen.name);
              Navigator.pushNamed(event.context, RouteDefine.connectScreen.name);
              CustomSnackBar.showSnackBar(context: event.context, title: AppLocalizations.of(event.context)!.logged_out_successfully, type: SnackBarType.success);
              emit(state.copyWith(isLogOutProcess: false));
            } else {
              CustomSnackBar.showSnackBar(context: event.context, title: AppStrings.getLocalizedStrings(response[AppStrings.messageString].toString().toLocalization(), event.context), type: SnackBarType.success);
              emit(state.copyWith(isLogOutProcess: false));
            }
          } on ServerException {
            emit(state.copyWith(isLogOutProcess: false));
          }
        } else if (event is _changeAppLanguageEvent) {
          if (state.isHebrewLanguage) {
            emit(state.copyWith(isHebrewLanguage: false));
            await Provider.of<LocaleProvider>(event.context, listen: false).setAppLocale(locale: const Locale(AppStrings.englishString));
          } else {
            emit(state.copyWith(isHebrewLanguage: true));
            await Provider.of<LocaleProvider>(event.context, listen: false).setAppLocale(locale: const Locale(AppStrings.hebrewString));
          }
        } else if (event is _getProfileDetailsEvent) {
          try {
            final res = await DioClient(event.context).post(
              AppUrls.getProfileDetailsUrl,
              data: ProfileDetailsReqModel(id: preferences.getUserId()).toJson(),
            );
            ProfileDetailsResModel response = ProfileDetailsResModel.fromJson(res);
            if (response.status == AppConstants.code_200) {
              if (!preferences.getSubUser()) {
                preferences.setUserImageUrl(imageUrl: response.data?.clients?.first.profileImage ?? '');
                emit(
                  state.copyWith(
                    UserImageUrl: response.data?.clients?.first.profileImage ?? '',
                  ),
                );
              }
            } else {
              CustomSnackBar.showSnackBar(context: event.context, title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context), type: SnackBarType.failure);
            }
          } catch (e) {
            printData(e.toString());
          }
        } else if (event is _getPermissionList) {
          if (preferences.getSubUser()) {
            try {
              final res = await DioClient(event.context).get(path: '${AppUrls.getAccountPermissionUrl}${preferences.getSubUserId()}');
              AccountPermissionResModel response = AccountPermissionResModel.fromJson(res);

              if (response.status == AppConstants.code_200) {
                var res = response.data?.permissions;

                if (preferences.getCanSeeWallet() != res?.canSeeWallet) {
                  event.context.read<BottomNavBloc>().add(BottomNavEvent.changePage(index: preferences.getCanSeeWallet() ? 4 : 3, context: event.context));
                }
                preferences.setCanSeeWallet(isSeeWallet: res?.canSeeWallet ?? false);
                emit(state.copyWith(isAccountPermissionShimmering: true));
                preferences.setCanAddBasket(isAddBasket: res?.canAddToCart ?? false);
                preferences.setCanCreateOrder(isCreateOrder: res?.canCreateOrder ?? false);
                preferences.setCanSeeOrder(isSeeOrder: res?.canSeeOrders ?? false);
                preferences.setCanDuplicateOrder(isDuplicateOrder: res?.canDuplicateOrders ?? false);
                preferences.setCanUpdateBusinessInfo(isUpdateBusinessInfo: res?.canSeeAndUpdateBusinessInfo ?? false);
                preferences.setCanUpdateAdditionalInfo(isUpdateAdditionalInfo: res?.canSeeAndUpdateAdditionalInfo ?? false);
                preferences.setCanUpdateTimeInfo(isUpdateTimeInfo: res?.canSeeAndUpdateTimesInfo ?? false);
                preferences.setCanSeeFormsFiles(isSeeFormsFiles: res?.canSeeFileAndForms ?? false);
                preferences.setManageSubUser(isManageSubUser: res?.canManageSubUsers ?? false);
                preferences.setCanSeeInvoices(isCanSeeInvoices: res?.canSeeInvoices ?? false);
                emit(state.copyWith(isSubUserSeeOrder: preferences.getCanSeeOrder(), isSubUserCanManageSubUser: preferences.getCanManageSubUser(), isSubUserUpdateTimeInfo: preferences.getCanUpdateTimeInfo(), isSubUserUpdateBusinessInfo: preferences.getCanUpdateBusinessInfo(), isSubUserUpdateAdditionalInfo: preferences.getCanUpdateAdditionalInfo(), isSubUserSeeFormsFiles: preferences.getCanSeeFormsFiles(), isAccountPermissionShimmering: false, isCanSeeInvoices: preferences.getCanSeeInvoices()));
              } else {
                CustomSnackBar.showSnackBar(context: event.context, title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context), type: SnackBarType.failure);
              }
            } catch (e) {
              CustomSnackBar.showSnackBar(context: event.context, title: e.toString(), type: SnackBarType.failure);
            }
          }
        } else if (event is _updateMaintenanceEvent) {
          emit(state.copyWith(isDialogOpen: true));
        } else if (event is _generalSettings) {
          try {
            emit(state.copyWith(retryLoading: event.isRetryLoading));

            final res = await DioClient(event.context).get(path: AppUrls.generalSettingUrl);
            SettingResModel response = SettingResModel.fromJson(res);

            if (response.status == AppConstants.code_200) {
              preferences.setBankTransferDetail(details: response.data?.taviliRivchitDetails?.bankTransferInfoText ?? '');

              if (preferences.getAppOnMaintenance() && !(response.data?.isAppOnMaintenance ?? false)) {
                add(ProfileMenuEvent.updateMaintenanceEvent(context: event.context));
                Navigator.pop(event.dialogContext);
                preferences.setIsAppOnMaintenance(isAppOnMaintenance: false);
                emit(state.copyWith(isDialogOpen: false, isAppOnMaintenance: false, retryLoading: false));
                return;
              } else {
                if (!state.isDialogOpen && !(response.data?.isAppOnMaintenance ?? false)) {
                  emit(state.copyWith(isDialogOpen: true));
                } else {
                  emit(state.copyWith(isDialogOpen: false));
                }
              }
              preferences.setIsSaleOn(isSaleOn: response.data?.isSaleOn ?? false);
              preferences.setIsIncludedVat(isIncludedVat: (response.data?.showVatApplication?.contains(AppStrings.appName) ?? false) ? true : false);
              preferences.setBottleTax(bottleDeposit: response.data?.bottlePrice ?? 0.0);
              preferences.setIsAppOnMaintenance(isAppOnMaintenance: response.data?.isAppOnMaintenance ?? false);

              emit(state.copyWith(language: preferences.getAppLanguage(), bottlePrice: response.data?.bottlePrice ?? 0.0, isIncludedVat: preferences.getIsIncludedVat(), isSaleOn: preferences.getShowSale(), retryLoading: false, isAppOnMaintenance: preferences.getAppOnMaintenance()));
            } else {}
          } catch (e) {
            CustomSnackBar.showSnackBar(context: event.context, title: e.toString(), type: SnackBarType.failure);
          }
        } else if (event is _userApproveEvent) {
          try {
            final res = await DioClient(event.context).post(AppUrls.verifyClientUrl, data: {AppStrings.clientIdString: preferences.getUserId()});
            VerifyClientResModel response = VerifyClientResModel.fromJson(res);

            if (response.status == AppConstants.code_200) {
              if (!(response.data?.isFilledForms ?? false) || !(response.data?.isRegisterForm ?? false)) {
                Navigator.pushNamed(event.context, RouteDefine.formDataScreen.name);
              } else if (!(response.data?.isUploadedFiles ?? false) && (response.data?.isRegisterForm ?? false) && (response.data?.isFilledForms ?? false)) {
                Navigator.pushNamed(event.context, RouteDefine.fileUploadScreen.name);
              }
            }
          } catch (e) {
            printData('catch____$e');
          }
        }
      }
    });
  }
}
