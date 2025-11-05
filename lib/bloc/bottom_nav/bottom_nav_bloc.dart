import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../data/model/bottom_nav_model/bottom_nav_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ui/utils/constants/app_strings.dart';

part 'bottom_nav_event.dart';
part 'bottom_nav_state.dart';
part 'bottom_nav_bloc.freezed.dart';

class BottomNavBloc extends Bloc<BottomNavEvent, BottomNavState> {
  BottomNavBloc() : super(BottomNavState.initial()) {
    bool isNavigation = true;
    on<BottomNavEvent>((event, emit) async {
      SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());

      if (event is _ChangePageEvent) {
        bool isGuestUser = preferencesHelper.getGuestUser();
        if (!isGuestUser && !preferencesHelper.getSubUser()) {
          if (state.arg != '' && preferencesHelper.getAppLanguage() == AppStrings.hebrewString) {
            emit(state.copyWith(
              index: state.index,
            ));
          } else {
            emit(state.copyWith(index: event.index));
          }
        } else if (preferencesHelper.getSubUser()) {
          if (preferencesHelper.getCanSeeWallet() != state.isSubUserSeeWallet) {
            emit(state.copyWith(index: 0));
          } else if (state.arg != '' && preferencesHelper.getAppLanguage() == AppStrings.hebrewString) {
            emit(state.copyWith(
              index: state.index,
            ));
          } else {
            emit(state.copyWith(
              index: event.index,
            ));
          }
        } else {
          emit(state.copyWith(isGuestUser: isGuestUser, index: event.index));
        }
        emit(state.copyWith(arg: ''));
        emit(state.copyWith(isSubUserSeeWallet: preferencesHelper.getCanSeeWallet()));
      } else if (event is _UpdateCartCountEvent) {
        emit(state.copyWith(isSubUserSeeWallet: preferencesHelper.getCanSeeWallet()));

        if (state.cartCount < preferencesHelper.getCartCount()) {
          emit(state.copyWith(isAnimation: true));
        }

        emit(state.copyWith(cartCount: preferencesHelper.getCartCount()));
        if (state.isAnimation) {
          await Future.delayed(const Duration(milliseconds: 1000));
          emit(state.copyWith(duringCelebration: true));
          await Future.delayed(const Duration(milliseconds: 2000));
          emit(state.copyWith(duringCelebration: false, isAnimation: false));
        }
      } else if (event is _NavigateToStoreScreenEvent) {
        emit(state.copyWith(isSubUserSeeWallet: preferencesHelper.getCanSeeWallet()));
        if (isNavigation) {
          if (event.basketScreen == 'true') {
            emit(state.copyWith(index: 2, arg: event.basketScreen));
          } else if (event.storeScreen == 'storeScreen') {
            emit(state.copyWith(index: 1, arg: event.storeScreen));
          } else if (event.storeScreen == 'basketScreen') {
            emit(state.copyWith(index: 2, arg: event.basketScreen));
          } else if (event.storeScreen == 'profileScreen') {
            emit(state.copyWith(index: 4, arg: event.profileScreen));
          }
        }
        isNavigation = false;
      } else if (event is _seeWalletPermissionUpdateEvent) {
        emit(state.copyWith(isSubUserSeeWallet: preferencesHelper.getCanSeeWallet()));
      } else if (event is _getPreferencesDataEvent) {
        emit(state.copyWith(isSubUserSeeWallet: preferencesHelper.getCanSeeWallet()));
      }
    });
  }
}
