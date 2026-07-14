import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/constants/app_strings.dart';
part 'bottom_nav_event.dart';
part 'bottom_nav_state.dart';
part 'bottom_nav_bloc.freezed.dart';

class BottomNavBloc extends Bloc<BottomNavEvent, BottomNavState> {
  bool _didHandleInitialNavigation = false;

  BottomNavBloc() : super(BottomNavState.initial()) {
    on<BottomNavEvent>((event, emit) async {
      final preferences =
          SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());

      if (event is _StartedEvent) {
        emit(state.copyWith(
            isGuestUser: preferences.getGuestUser(),
            isSubUserSeeWallet: preferences.getCanSeeWallet(),
            cartCount: preferences.getCartCount()));
        add(BottomNavEvent.navigateToStoreScreenEvent(
            context: event.context,
            storeScreen: event.storeScreen,
            profileScreen: event.profileScreen,
            basketScreen: event.basketScreen));
      } else if (event is _ChangePageEvent) {
        await _handleChangePage(event, preferences, emit);
      } else if (event is _UpdateCartCountEvent) {
        await _handleCartBadgeUpdate(preferences, emit);
      } else if (event is _seeWalletPermissionUpdateEvent ||
          event is _getPreferencesDataEvent) {
        _emitWalletPermission(preferences, emit);
      } else if (event is _NavigateToStoreScreenEvent) {
        _handleInitialNavigation(event, preferences, emit);
      } else if (event is _SetDialogOpenEvent) {
        // Kept for API compatibility; dialog open state is owned by feature blocs.
      }
    });
  }

  void _emitWalletPermission(
      SharedPreferencesHelper preferences, Emitter<BottomNavState> emit) {
    emit(state.copyWith(
        isSubUserSeeWallet: preferences.getCanSeeWallet(),
        isGuestUser: preferences.getGuestUser()));
  }

  Future<void> _handleChangePage(
    _ChangePageEvent event,
    SharedPreferencesHelper preferences,
    Emitter<BottomNavState> emit,
  ) async {
    final isGuestUser = preferences.getGuestUser();
    final canSeeWallet = preferences.getCanSeeWallet();

    if (isGuestUser && event.index != 0 && event.index != 1) {
      if (event.context.mounted) {
        Navigator.pushNamed(event.context, RouteDefine.connectScreen.name);
      }
      emit(state.copyWith(isGuestUser: true, isSubUserSeeWallet: canSeeWallet));
      return;
    }

    var nextIndex = event.index;

    if (!isGuestUser && !preferences.getSubUser()) {
      if (state.arg != '' &&
          preferences.getAppLanguage() == AppStrings.hebrewString) {
        nextIndex = state.index;
      }
    } else if (preferences.getSubUser()) {
      if (canSeeWallet != state.isSubUserSeeWallet) {
        nextIndex = 0;
      } else if (state.arg != '' &&
          preferences.getAppLanguage() == AppStrings.hebrewString) {
        nextIndex = state.index;
      }
    }

    emit(state.copyWith(
        index: nextIndex,
        arg: '',
        isGuestUser: isGuestUser,
        isSubUserSeeWallet: canSeeWallet));
  }

  Future<void> _handleCartBadgeUpdate(
    SharedPreferencesHelper preferences,
    Emitter<BottomNavState> emit
  ) async {
    final latestCount = preferences.getCartCount();
    final shouldAnimate = state.cartCount < latestCount;

    emit(state.copyWith(
        isSubUserSeeWallet: preferences.getCanSeeWallet(),
        isGuestUser: preferences.getGuestUser(),
        isAnimation: shouldAnimate,
        cartCount: latestCount));

    if (!shouldAnimate) return;

    await Future.delayed(const Duration(milliseconds: 1000));
    if (isClosed) return;
    emit(state.copyWith(duringCelebration: true));

    await Future.delayed(const Duration(milliseconds: 2000));
    if (isClosed) return;
    emit(state.copyWith(duringCelebration: false, isAnimation: false));
  }

  void _handleInitialNavigation(_NavigateToStoreScreenEvent event,
      SharedPreferencesHelper preferences, Emitter<BottomNavState> emit) {
    final canSeeWallet = preferences.getCanSeeWallet();
    emit(state.copyWith(isSubUserSeeWallet: canSeeWallet));

    if (_didHandleInitialNavigation) return;
    _didHandleInitialNavigation = true;

    if (event.basketScreen == 'true') {
      emit(state.copyWith(index: 2, arg: event.basketScreen));
    } else if (event.storeScreen == 'storeScreen') {
      emit(state.copyWith(index: 1, arg: event.storeScreen));
    } else if (event.storeScreen == 'basketScreen') {
      emit(state.copyWith(index: 2, arg: event.basketScreen));
    } else if (event.storeScreen == 'profileScreen') {
      emit(state.copyWith(
          index: canSeeWallet ? 4 : 3, arg: event.profileScreen));
    }
  }
}
