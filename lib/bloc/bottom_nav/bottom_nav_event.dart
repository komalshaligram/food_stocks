part of 'bottom_nav_bloc.dart';

@freezed
class BottomNavEvent with _$BottomNavEvent {
  factory BottomNavEvent.changePage({required int index}) = _ChangePageEvent;

  const factory BottomNavEvent.updateCartCountEvent(

) = _UpdateCartCountEvent;

  const factory BottomNavEvent.cartAnimationEvent({
    required int cartCount,
}) = _cartAnimationEvent;
}
