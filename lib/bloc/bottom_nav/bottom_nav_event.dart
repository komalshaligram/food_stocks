part of 'bottom_nav_bloc.dart';

@freezed
class BottomNavEvent with _$BottomNavEvent {
  factory BottomNavEvent.changePage({required int index,required BuildContext context,}) = _ChangePageEvent;

  const factory BottomNavEvent.updateCartCountEvent({required BuildContext context}) = _UpdateCartCountEvent;


  const factory BottomNavEvent.NavigateToStoreScreenEvent(
      {required BuildContext context,
        required String storeScreen,
        required String basketScreen,
      }) = _NavigateToStoreScreenEvent;

  const factory BottomNavEvent.seeWalletPermissionUpdateEvent({required BuildContext context}) = _seeWalletPermissionUpdateEvent;
  const factory BottomNavEvent.getPreferencesDataEvent({required BuildContext context}) = _getPreferencesDataEvent;
}
