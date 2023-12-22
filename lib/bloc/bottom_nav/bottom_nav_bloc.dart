import 'package:bloc/bloc.dart';

import 'package:flutter/material.dart';
import 'package:food_stock/data/storage/shared_preferences_helper.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../routes/app_routes.dart';

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
        if (state.cartCount < preferencesHelper.getCartCount()) {
          emit(state.copyWith(isAnimation: true));
        }
        emit(state.copyWith(cartCount: preferencesHelper.getCartCount()));
        debugPrint('cart count = ${state.cartCount}');
      } else if (event is _PushNavigationEvent) {
        debugPrint('push = ${event.pushNavigation}');
        if (event.pushNavigation.isNotEmpty) {
          emit(state.copyWith(index: 1));
          if (event.pushNavigation == 'companyScreen') {
            debugPrint('push companyScreen');
            Navigator.pushNamed(event.context, RouteDefine.companyScreen.name);
          } else if (event.pushNavigation == 'companyProductsScreen') {
            debugPrint('push companyProductsScreen');
            Navigator.pushNamed(
                event.context, RouteDefine.companyProductsScreen.name);
          } else if (event.pushNavigation == 'productSaleScreen') {
            debugPrint('push productSaleScreen');
            Navigator.pushNamed(
                event.context, RouteDefine.productSaleScreen.name);
          } else if (event.pushNavigation == 'supplierScreen') {
            debugPrint('push supplierScreen');
            Navigator.pushNamed(event.context, RouteDefine.supplierScreen.name);
          } else if (event.pushNavigation == 'supplierProductsScreen') {
            debugPrint('push supplierProductsScreen');
            Navigator.pushNamed(
                event.context, RouteDefine.supplierProductsScreen.name);
          } else if (event.pushNavigation == 'storeCategoryScreen') {
            debugPrint('push storeCategoryScreen');
            Navigator.pushNamed(
                event.context, RouteDefine.storeCategoryScreen.name);
          } else if (event.pushNavigation == 'planogramProductScreen') {
            debugPrint('push planogramProductScreen');
            Navigator.pushNamed(
                event.context, RouteDefine.planogramProductScreen.name);
          }
        }
      }
    });
  }
}
