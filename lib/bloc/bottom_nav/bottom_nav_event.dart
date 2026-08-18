part of 'bottom_nav_bloc.dart';

@freezed
class BottomNavEvent with _$BottomNavEvent {
  const factory BottomNavEvent.started(
      {required BuildContext context, required String storeScreen, required String profileScreen, required String basketScreen}) = _StartedEvent;

  factory BottomNavEvent.changePage({required int index, required BuildContext context}) = _ChangePageEvent;

  const factory BottomNavEvent.updateCartCountEvent({required BuildContext context}) = _UpdateCartCountEvent;

  const factory BottomNavEvent.seeWalletPermissionUpdateEvent({required BuildContext context}) = _seeWalletPermissionUpdateEvent;

  const factory BottomNavEvent.getPreferencesDataEvent({required BuildContext context}) = _getPreferencesDataEvent;

  const factory BottomNavEvent.navigateToStoreScreenEvent(
      {required BuildContext context,
      required String storeScreen,
      required String profileScreen,
      required String basketScreen}) = _NavigateToStoreScreenEvent;
}
