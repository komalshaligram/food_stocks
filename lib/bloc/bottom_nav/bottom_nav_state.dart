part of 'bottom_nav_bloc.dart';

@freezed
class BottomNavState with _$BottomNavState {
  const factory BottomNavState({
    required int index,
    required int cartCount,
    required bool isAnimation,
    required String pushNotificationPath,
    required bool duringCelebration,
  }) = _BottomNavState;

  factory BottomNavState.initial() => const BottomNavState(
        index: 0,
        cartCount: 0,
        isAnimation: false,
        pushNotificationPath: '',
        duringCelebration: false,
      );
}
