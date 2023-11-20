import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:food_stock/routes/app_routes.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../../data/services/locale_provider.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_colors.dart';
import '../../ui/utils/themes/app_strings.dart';
import '../../ui/widget/common_alert_dialog.dart';

part 'profile_menu_event.dart';

part 'profile_menu_state.dart';

part 'profile_menu_bloc.freezed.dart';

class ProfileMenuBloc extends Bloc<ProfileMenuEvent, ProfileMenuState> {
  ProfileMenuBloc() : super(ProfileMenuState.initial()) {
    on<ProfileMenuEvent>((event, emit) async {
      if (event is _getPreferenceDataEvent) {
        SharedPreferencesHelper preferences = SharedPreferencesHelper(
            prefs: await SharedPreferences.getInstance());

        debugPrint('UserImageUrl  ${preferences.getUserImageUrl()}');
        debugPrint('username   ${preferences.getUserName()}');
        debugPrint('logo  ${preferences.getUserCompanyLogoUrl()}');
        emit(state.copyWith(UserImageUrl: preferences.getUserImageUrl()));
        emit(state.copyWith(
            UserCompanyLogoUrl: preferences.getUserCompanyLogoUrl()));
        emit(state.copyWith(userName: preferences.getUserName()));
      } else if (event is _logOutEvent) {
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
      } else if (event is _GetAppLanguage) {
        SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(
            prefs: await SharedPreferences.getInstance());
        String appLang = preferencesHelper.getAppLanguage();
        if (appLang == AppStrings.hebrewString) {
          emit(state.copyWith(isHebrewLanguage: true));
        }
      } else if (event is _logOutEvent) {
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
      } else if (event is _ChangeAppLanguageEvent) {
        if (state.isHebrewLanguage) {
          emit(state.copyWith(isHebrewLanguage: false));
          await Provider.of<LocaleProvider>(event.context, listen: false)
              .setAppLocale(locale: Locale(AppStrings.englishString));
        } else {
          emit(state.copyWith(isHebrewLanguage: true));
          await Provider.of<LocaleProvider>(event.context, listen: false)
              .setAppLocale(locale: Locale(AppStrings.hebrewString));
        }
      }
    });
  }
}
