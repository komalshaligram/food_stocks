part of 'profile_menu_bloc.dart';

@freezed
class ProfileMenuState with _$ProfileMenuState {
  const factory ProfileMenuState({
    required String UserImageUrl,
    required String UserCompanyLogoUrl,
    required String userName
  }) = _ProfileMenuState;
  factory ProfileMenuState.initial()=>  ProfileMenuState(
    UserImageUrl: '',
    UserCompanyLogoUrl: '',
    userName: '',
  );
}
