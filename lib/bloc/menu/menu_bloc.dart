import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:food_stock/data/services/locale_provider.dart';
import 'package:food_stock/routes/app_routes.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:food_stock/ui/widget/common_alert_dialog.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../../data/storage/shared_preferences_helper.dart';

part 'menu_event.dart';

part 'menu_state.dart';

part 'menu_bloc.freezed.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc() : super(const MenuState.initial()) {
    on<MenuEvent>((event, emit) async {
      if (event is _logOutEvent) {
        showDialog(
          context: event.context,
          builder: (context) => CommonAlertDialog(
            title: "Log Out",
            subTitle: 'Are you sure?',
            positiveTitle: 'Yes',
            negativeTitle: 'No',
            negativeOnTap: () {
              Navigator.pop(context);
            },
            positiveOnTap: () async {
              SharedPreferencesHelper preferencesHelper =
                  SharedPreferencesHelper(
                      prefs: await SharedPreferences.getInstance());
              await preferencesHelper.setUserLoggedIn();
              showSnackBar(
                  context: event.context,
                  title: AppStrings.logOutSuccessString,
                  bgColor: AppColors.mainColor);
              Navigator.pop(context);
              Navigator.popUntil(event.context,
                  (route) => route.name == RouteDefine.bottomNavScreen.name);
              Navigator.pushNamed(
                  event.context, RouteDefine.connectScreen.name);
            },
          ),
        );
      } /*else if (event is _ChangeAppLanguageEvent) {
        SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(
            prefs: await SharedPreferences.getInstance());
        if (preferencesHelper.getAppLanguage() == "en") {
          await LocaleProvider().setAppLocale(Locale('he'));
          final provider = Provider.of<LocaleProvider>(event.context);
        } else {
          await LocaleProvider().setAppLocale(Locale('en'));
        }
      }*/
    });
  }
}
