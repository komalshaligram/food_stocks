import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/model/res_model/setting_res_model/setting_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/constants/app_constants.dart';
import '../../ui/utils/constants/app_strings.dart';
import '../../ui/utils/constants/app_urls.dart';

part 'registration_success_event.dart';
part 'registration_success_state.dart';
part 'registration_success_bloc.freezed.dart';

class RegistrationSuccessBloc extends Bloc<RegistrationSuccessEvent, RegistrationSuccessState> {
  RegistrationSuccessBloc() : super(RegistrationSuccessState.initial()) {
    on<RegistrationSuccessEvent>((event, emit) async {
      SharedPreferencesHelper preferences = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());

      if (event is _generalSettings) {
        try {
          final res = await DioClient(event.context).get(path: AppUrlEndPoints.generalSettingUrl);
          SettingResModel response = SettingResModel.fromJson(res);
          if (response.status == AppConstants.code_200) {
            if (preferences.getAppOnMaintenance() && !(response.data?.isAppOnMaintenance ?? false)) {
              preferences.setIsAppOnMaintenance(isAppOnMaintenance: false);
              return;
            }
            emit(state.copyWith(registrationSuccessMessage: response.data?.registrationSuccessPageSettings?.registrationSuccessPageText! ?? ''));
            preferences.setIsIncludedVat(isIncludedVat: (response.data?.showVatApplication?.contains(AppStrings.appName) ?? false) ? true : false);
          }
        } catch (e) {
          CustomSnackBar.showSnackBar(context: event.context, title: e.toString(), type: SnackBarType.failure);
        }
      }

      if (event is _celebrationEvent) {
        await Future.delayed(const Duration(milliseconds: 2000));
        emit(state.copyWith(duringCelebration: false));
      }
    });
  }
}
