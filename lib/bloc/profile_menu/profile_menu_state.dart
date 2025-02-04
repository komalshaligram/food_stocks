part of 'profile_menu_bloc.dart';

@freezed
class ProfileMenuState with _$ProfileMenuState {
  const factory ProfileMenuState({
    required String UserImageUrl,
    required String UserCompanyLogoUrl,
    required String userName,
    required bool isHebrewLanguage,
    required bool isLogOut,
    required bool isLogOutProcess,
    required String language,
    required String applicationVersion,
    required String buildNumber,
    required bool isSubUserUpdateBusinessInfo,
    required bool isSubUserUpdateAdditionalInfo,
    required bool isSubUserUpdateTimeInfo,
    required bool isSubUserSeeFormsFiles,
    required bool isSubUserCanManageSubUser,
    required bool isSubUserSeeOrder,
    required bool isSubUserSeeReturns,
    required bool isAccountPermissionShimmering,
    required bool isCanSeeInvoices,
    required bool isAppOnMaintenance,
    required bool isDialogOpen,
    required bool isIncludedVat,
    required bool isSaleOn,
    required double bottlePrice,
    required bool retryLoading

  }) = _ProfileMenuState;

  factory ProfileMenuState.initial() => ProfileMenuState(
        UserImageUrl: '',
        UserCompanyLogoUrl: '',
        userName: '',
        isHebrewLanguage: false,
    isLogOut: false,
    isLogOutProcess: false,
    language: AppStrings.hebrewString,
      applicationVersion: "1.0.0",
      buildNumber: '1',
    isSubUserSeeFormsFiles: false,
      isSubUserSeeReturns:false,
    isSubUserUpdateAdditionalInfo: false,
    isSubUserUpdateBusinessInfo: false,
    isSubUserUpdateTimeInfo: false,
    isSubUserCanManageSubUser: false,
    isSubUserSeeOrder: false,
      isAccountPermissionShimmering: false,
    isCanSeeInvoices: false,
      isAppOnMaintenance  : false,
      isDialogOpen:false,
    bottlePrice: 0,
    isIncludedVat: false,
    isSaleOn: false,
    retryLoading: false
      );
}
