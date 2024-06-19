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
    required bool isAccountPermissionShimmering,
    required bool isCanSeeInvoices,


  }) = _ProfileMenuState;

  factory ProfileMenuState.initial() => ProfileMenuState(
        UserImageUrl: '',
        UserCompanyLogoUrl: '',
        userName: '',
        isHebrewLanguage: false,
    isLogOut: false,
    isLogOutProcess: false,
    language: 'he',
      applicationVersion: "1.0.0",
      buildNumber: '1',
    isSubUserSeeFormsFiles: false,
    isSubUserUpdateAdditionalInfo: false,
    isSubUserUpdateBusinessInfo: false,
    isSubUserUpdateTimeInfo: false,
    isSubUserCanManageSubUser: false,
    isSubUserSeeOrder: false,
      isAccountPermissionShimmering: false,
    isCanSeeInvoices: false,
    
      );
}
