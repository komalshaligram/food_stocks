part of 'profile_menu_bloc.dart';

@freezed
class ProfileMenuEvent with _$ProfileMenuEvent {
  const factory ProfileMenuEvent.getPreferenceDataEvent() =
      _getPreferenceDataEvent;

  const factory ProfileMenuEvent.getAppLanguage() = _GetAppLanguage;

  const factory ProfileMenuEvent.logOutEvent({required BuildContext context}) =
      _logOutEvent;

  const factory ProfileMenuEvent.changeAppLanguageEvent(
      {required BuildContext context}) = _ChangeAppLanguageEvent;

  const factory ProfileMenuEvent.getProfileDetailsEvent({
    required BuildContext context,
  }) = _getProfileDetailsEvent;

  const factory ProfileMenuEvent.getPermissionList(
      {required BuildContext context}) = _getPermissionList;

  const factory ProfileMenuEvent.userApproveEvent(
      {required BuildContext context}) = _userApproveEvent;

  const factory ProfileMenuEvent.generalSettings({required BuildContext context,required BuildContext dialogContext})=_GeneralSettings;

  const factory ProfileMenuEvent.updateMaintenanceEvent(
      {required BuildContext context}) = _updateMaintenanceEvent;
}
