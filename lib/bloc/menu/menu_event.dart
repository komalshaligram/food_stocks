part of 'menu_bloc.dart';

@freezed
class MenuEvent with _$MenuEvent {
  const factory MenuEvent.getAppContentListEvent(
      {required BuildContext context}) = _GetAppContentListEvent;

  const factory MenuEvent.refreshListEvent({required BuildContext context}) =
      _RefreshListEvent;
}
