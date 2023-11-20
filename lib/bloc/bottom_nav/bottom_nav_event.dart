part of 'bottom_nav_bloc.dart';

@freezed
class BottomNavEvent with _$BottomNavEvent {
  factory BottomNavEvent.changePage({required int index}) = _ChangePageEvent;

  const factory BottomNavEvent.updateCartCountEvent({required int cartCount}) =
      _UpdateCartCountEvent;

  const factory BottomNavEvent.resetCartCountEvent() = _ResetCartCountEvent;
}
