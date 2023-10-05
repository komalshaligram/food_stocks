part of 'menu_bloc.dart';

@freezed
class MenuEvent with _$MenuEvent {
  const factory MenuEvent.logOutEvent({required BuildContext context}) =
      _logOutEvent;
}
