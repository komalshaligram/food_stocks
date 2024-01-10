part of 'bottom_nav_bloc.dart';

@freezed
class BottomNavEvent with _$BottomNavEvent {
  factory BottomNavEvent.changePage({required int index}) = _ChangePageEvent;

  const factory BottomNavEvent.updateCartCountEvent() = _UpdateCartCountEvent;

  const factory BottomNavEvent.animationCartEvent() = _animationCartEvent;
  const factory BottomNavEvent.snackbarEvent({
    required bool isBottomNavBar
}) = _snackbarEvent;

  const factory BottomNavEvent.PushNavigationEvent(
      {required BuildContext context,
      required String pushNavigation}) = _PushNavigationEvent;
}
