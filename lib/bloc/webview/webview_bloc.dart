// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../data/error/exceptions.dart';
// import '../../data/model/res_model/setting_res_model/setting_res_model.dart';
// import '../../data/storage/shared_preferences_helper.dart';
// import '../../repository/dio_client.dart';
// import '../../ui/utils/app_utils.dart';
// import '../../ui/utils/constants/app_urls.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../ui/utils/constants/app_constants.dart';
// import '../../ui/utils/constants/app_strings.dart';
//
// part 'webview_event.dart';
// part 'webview_state.dart';
// part 'webview_bloc.freezed.dart';
//
// class WebviewBloc extends Bloc<WebViewEvent, WebViewState> {
//   WebviewBloc() : super(WebViewState.initial()) {
//     on<_generalSettings>(_onGeneralSettings);
//     on<_updateMaintenanceEvent>(_onUpdateMaintenance);
//   }
//
//   Future<void> _onGeneralSettings(
//       _generalSettings event,
//       Emitter<WebViewState> emit,
//       ) async {
//     emit(state.copyWith(isShimmering: true));
//
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final preferencesHelper = SharedPreferencesHelper(prefs: prefs);
//
//       final res = await DioClient(event.context)
//           .get(path: AppUrlEndPoints.generalSettingUrl);
//
//       final response = SettingResModel.fromJson(res);
//
//       if (response.status == AppConstants.code_200) {
//         emit(state.copyWith(
//           isShimmering: false,
//           language: preferencesHelper.getAppLanguage(),
//           isAppOnMaintenance: preferencesHelper.getAppOnMaintenance(),
//           showClientDataOnApp: preferencesHelper.getClientDataOnApp(),
//           screenEnglishTitle:
//           response.data?.dataWebViewSettings?.screenEnglishTitle,
//           screenHebrewTitle:
//           response.data?.dataWebViewSettings?.screenHebrewTitle,
//           userId: preferencesHelper.getUserId(),
//           baseUrl: response.data?.dataWebViewSettings?.baseUrl,
//         ));
//       } else {
//         emit(state.copyWith(isShimmering: false));
//       }
//     } on ServerException {
//       emit(state.copyWith(isShimmering: false));
//     } catch (e) {
//       emit(state.copyWith(isShimmering: false));
//       CustomSnackBar.showSnackBar(
//         context: event.context,
//         title: e.toString(),
//         type: SnackBarType.failure,
//       );
//     }
//   }
//
//   void _onUpdateMaintenance(
//       _updateMaintenanceEvent event,
//       Emitter<WebViewState> emit,
//       ) {
//     emit(state.copyWith(isDialogOpen: true));
//   }
// }
//

// OLD CODE


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/res_model/setting_res_model/setting_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/constants/app_urls.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ui/utils/constants/app_constants.dart';
import '../../ui/utils/constants/app_strings.dart';

part 'webview_event.dart';
part 'webview_state.dart';
part 'webview_bloc.freezed.dart';

class WebviewBloc extends Bloc<WebViewEvent, WebViewState> {

  WebviewBloc() : super(WebViewState.initial()) {
    on<WebViewEvent>((event, emit) async {
      SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
      SharedPreferencesHelper preferences = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());


      if (event is _generalSettings) {
        try {
          emit(state.copyWith(isShimmering: true));

          final res = await DioClient(event.context)
              .get(path: AppUrlEndPoints.generalSettingUrl);

          SettingResModel response = SettingResModel.fromJson(res);

          if (response.status == AppConstants.code_200) {



            emit(state.copyWith(
              isShimmering: false,
              language: preferencesHelper.getAppLanguage(),
              isAppOnMaintenance: preferencesHelper.getAppOnMaintenance(),
              showClientDataOnApp: preferencesHelper.getClientDataOnApp(),
              screenEnglishTitle : response.data?.dataWebViewSettings?.screenEnglishTitle,
              screenHebrewTitle: response.data?.dataWebViewSettings?.screenHebrewTitle,
              userId: preferences.getUserId(),
              baseUrl: response.data?.dataWebViewSettings?.baseUrl,
            ));
          } else {
            emit(state.copyWith(isShimmering: false));
          }
        } on ServerException {
          emit(state.copyWith(isShimmering: false));
        } catch (e) {
          emit(state.copyWith(isShimmering: false));
          CustomSnackBar.showSnackBar(
            context: event.context,
            title: e.toString(),
            type: SnackBarType.failure,
          );
        }
      }
      else if (event is _updateMaintenanceEvent) {
        emit(state.copyWith(isDialogOpen: true));
      }
    });
  }
}