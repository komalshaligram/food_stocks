part of 'bottom_nav_bloc.dart';

@freezed
class BottomNavState with _$BottomNavState {
  const factory BottomNavState({
    required int index,
    required int cartCount,
  }) = _BottomNavState;

  factory BottomNavState.initial() => const BottomNavState(
        index: 4,
        cartCount: 0,
      );
}
