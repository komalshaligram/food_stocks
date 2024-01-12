part of 'profile_menu_bloc.dart';

@freezed
class ProfileMenuState with _$ProfileMenuState {
  const factory ProfileMenuState({
    required String UserImageUrl,
    required String UserCompanyLogoUrl,
    required String userName,
    required bool isHebrewLanguage,
    required bool isLogOut,
    required bool isLogOutProcess
  }) = _ProfileMenuState;

  factory ProfileMenuState.initial() => ProfileMenuState(
        UserImageUrl: '',
        UserCompanyLogoUrl: '',
        userName: '',
        isHebrewLanguage: false,
    isLogOut: false,
    isLogOutProcess: false
      );
}
