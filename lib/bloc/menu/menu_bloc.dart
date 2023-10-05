import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:food_stock/routes/app_routes.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/storage/shared_preferences_helper.dart';

part 'menu_event.dart';

part 'menu_state.dart';

part 'menu_bloc.freezed.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc() : super(const MenuState.initial()) {
    on<MenuEvent>((event, emit) async {
      if (event is _logOutEvent) {
        SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(
            prefs: await SharedPreferences.getInstance());
        await preferencesHelper.setUserLoggedIn();
        showSnackBar(
            context: event.context,
            title: AppStrings.logOutSuccessString,
            bgColor: AppColors.mainColor);
        Navigator.popUntil(event.context,
            (route) => route.name == RouteDefine.bottomNavScreen.name);
        Navigator.pushNamed(event.context, RouteDefine.connectScreen.name);
      }
    });
  }
}
