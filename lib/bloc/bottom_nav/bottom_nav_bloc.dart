import 'package:bloc/bloc.dart';

import 'package:flutter/material.dart';
import 'package:food_stock/data/storage/shared_preferences_helper.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'bottom_nav_event.dart';

part 'bottom_nav_state.dart';

part 'bottom_nav_bloc.freezed.dart';

class BottomNavBloc extends Bloc<BottomNavEvent, BottomNavState> {
  BottomNavBloc() : super(BottomNavState.initial()) {
    on<BottomNavEvent>((event, emit) async {
      SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(
          prefs: await SharedPreferences.getInstance());
      if (event is _ChangePageEvent) {
        emit(state.copyWith(index: event.index));
      } else if (event is _UpdateCartCountEvent) {

        emit(state.copyWith(cartCount: preferencesHelper.getCartCount()));
        debugPrint('cart count = ${state.cartCount}');
      }
      else if(event is _cartAnimationEvent){
        if(event.cartCount < preferencesHelper.getCartCount()){
          emit(state.copyWith(isAnimation: true));
        }
      }
    });
  }
}
