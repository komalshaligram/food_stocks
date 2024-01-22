import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:food_stock/data/error/exceptions.dart';
import 'package:food_stock/repository/dio_client.dart';
import 'package:food_stock/routes/app_routes.dart';
import 'package:food_stock/ui/utils/themes/app_urls.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../../data/model/req_model/profile_details_req_model/profile_details_req_model.dart';
import '../../data/model/res_model/profile_details_res_model/profile_details_res_model.dart';
import '../../data/services/locale_provider.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_strings.dart';
import '../../ui/widget/common_alert_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'profile_menu_event.dart';

part 'profile_menu_state.dart';

part 'profile_menu_bloc.freezed.dart';

class ProfileMenuBloc extends Bloc<ProfileMenuEvent, ProfileMenuState> {
  ProfileMenuBloc() : super(ProfileMenuState.initial()) {
    on<ProfileMenuEvent>((event, emit) async {
      SharedPreferencesHelper preferences =
          SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());

      if (event is _getPreferenceDataEvent) {
        debugPrint('[UserImageUrl]  ${preferences.getUserImageUrl()}');
        debugPrint('[username]   ${preferences.getUserName()}');
        debugPrint('[logo]  ${preferences.getUserCompanyLogoUrl()}');
        emit(state.copyWith(UserImageUrl: preferences.getUserImageUrl(),language: preferences.getAppLanguage()));
        emit(state.copyWith(
            UserCompanyLogoUrl: preferences.getUserCompanyLogoUrl()));
        emit(state.copyWith(userName: preferences.getUserName()));
      } else if (event is _GetAppLanguage) {
        SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(
            prefs: await SharedPreferences.getInstance());
        String appLang = preferencesHelper.getAppLanguage();
        if (appLang == AppStrings.hebrewString) {
          emit(state.copyWith(isHebrewLanguage: true));
        }
      }
      else if (event is _logOutEvent) {
        emit(state.copyWith(isLogOutProcess: true));
        try {
          final response = await DioClient(event.context).put(
              path: AppUrls.logOutUrl,
              data: {"userId": preferences.getUserId()});

          debugPrint('logOut url  = ${AppUrls.baseUrl}${AppUrls.logOutUrl}');

          debugPrint('logOut response  = ${response}');

          if (response[AppStrings.statusString] == 200) {
            SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(
                prefs: await SharedPreferences.getInstance());
            await preferencesHelper.setUserLoggedIn();
            await Provider.of<LocaleProvider>(event.context, listen: false)
                .setAppLocale(locale: Locale(AppStrings.hebrewString));
            Navigator.pop(event.context);
            Navigator.popUntil(event.context,
                (route) => route.name == RouteDefine.bottomNavScreen.name);
            Navigator.pushNamed(event.context, RouteDefine.connectScreen.name);
            CustomSnackBar.showSnackBar(
                context: event.context,
                title:
                    '${AppLocalizations.of(event.context)!.logged_out_successfully}',
                type: SnackBarType.SUCCESS);
            emit(state.copyWith(isLogOutProcess: false));
          } else {
            CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(
                    response[AppStrings.messageString]
                        .toString()
                        .toLocalization(),
                    event.context),
                type: SnackBarType.SUCCESS);
            emit(state.copyWith(isLogOutProcess: false));
          }
        } on ServerException {
          emit(state.copyWith(isLogOutProcess: false));
        }
      }
      else if (event is _ChangeAppLanguageEvent) {
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
      else if (event is _getProfileDetailsEvent) {

        try {
          debugPrint('req = ${preferences.getUserId()}');
          final res = await DioClient(event.context).post(
              AppUrls.getProfileDetailsUrl,
              data: ProfileDetailsReqModel(id: preferences.getUserId())
                  .toJson(),
            );
          debugPrint('res = ${res}');
          ProfileDetailsResModel response =
          ProfileDetailsResModel.fromJson(res);
          if (response.status == 200) {
            debugPrint(
                'image = ${response.data?.clients?.first.profileImage}');
            preferences.setUserImageUrl(imageUrl: response.data?.clients?.first.profileImage ?? '');
            preferences.setUserCompanyLogoUrl(logoUrl: response.data?.clients?.first.logo ?? '');
            emit(
              state.copyWith(
                  UserImageUrl: response.data?.clients?.first.profileImage ?? '',
                  UserCompanyLogoUrl :response.data?.clients?.first.logo ?? ''
              ),
            );
          } else {
            CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(
                    response.message?.toLocalization() ??
                        'something_is_wrong_try_again',
                    event.context),
                type: SnackBarType.FAILURE);
          }
        } on ServerException {

        } catch (e) {

        }

      }
    });
  }
}
