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
        bool isGuestUser = preferencesHelper.getGuestUser();

        if(!isGuestUser){
          emit(state.copyWith(index: event.index));
        }
        else{
          emit(state.copyWith(isGuestUser:isGuestUser ,index: event.index));
        }
      } else if (event is _UpdateCartCountEvent) {
     emit(state.copyWith(isAnimation: false));
     if(state.cartCount < preferencesHelper.getCartCount()){
       emit(state.copyWith(isAnimation: preferencesHelper.getIsAnimation()));
     }
     emit(state.copyWith(cartCount: preferencesHelper.getCartCount()));
        if(state.isAnimation){
          await Future.delayed(const Duration(milliseconds: 1000));
          emit(state.copyWith(duringCelebration:true));
          await Future.delayed(const Duration(milliseconds: 2000));
          emit(state.copyWith(duringCelebration:false,isAnimation: false));
        }
        debugPrint('cart count = ${state.cartCount}');
      }
      else if(event is _NavigateToStoreScreenEvent){
        bool isGuestUser = preferencesHelper.getGuestUser();
        if(isGuestUser){
          emit(state.copyWith(index: 1,isGuestUser: isGuestUser));
        }
      }
    });
  }
}
