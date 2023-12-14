part of 'bottom_nav_bloc.dart';

@freezed
class BottomNavState with _$BottomNavState {
  const factory BottomNavState({
    required int index,
    required int cartCount,
    required bool isAnimation

    //late ConfettiController _controllerCenter;
  }) = _BottomNavState;

  factory BottomNavState.initial() => const BottomNavState(
        index: 4,
        cartCount: 0,
    isAnimation: false,
      );
}