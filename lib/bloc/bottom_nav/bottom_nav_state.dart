part of 'bottom_nav_bloc.dart';

@freezed
class BottomNavState with _$BottomNavState {
  const BottomNavState._();

  const factory BottomNavState({
    required int index,
    required int cartCount,
    required bool isAnimation,
    required String pushNotificationPath,
    required bool duringCelebration,
    required String isStoreScreen,
    required bool isGuestUser,
    required String arg,
    required bool isSubUserSeeWallet,
    required bool isRefreshing,
  }) = _BottomNavState;

  factory BottomNavState.initial() => const BottomNavState(
        index: 0,
        cartCount: 0,
        isAnimation: false,
        pushNotificationPath: '',
        duringCelebration: false,
        isStoreScreen: '',
        isGuestUser: false,
        arg: '',
        isSubUserSeeWallet: true,
        isRefreshing: false,
      );

  List<int> get visibleNavPages =>
      isSubUserSeeWallet ? const [0, 2, 3, 4] : const [0, 2, 3];

  int get selectedNavIndex {
    final i = visibleNavPages.indexOf(index);
    return i < 0 ? 0 : i;
  }

  bool get showCartBadge => cartCount > 0 && index != 2;

  int get profilePageIndex => isSubUserSeeWallet ? 4 : 3;
}
