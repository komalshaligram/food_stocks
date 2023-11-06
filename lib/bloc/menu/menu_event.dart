part of 'menu_bloc.dart';

@freezed
class MenuEvent with _$MenuEvent {
  const factory MenuEvent.getAppLanguage() = _GetAppLanguage;

  const factory MenuEvent.logOutEvent({required BuildContext context}) =
      _logOutEvent;

  const factory MenuEvent.changeAppLanguageEvent(
      {required BuildContext context}) = _ChangeAppLanguageEvent;
}
