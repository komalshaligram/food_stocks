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
}
