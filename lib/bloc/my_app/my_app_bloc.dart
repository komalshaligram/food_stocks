import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../ui/utils/constants/app_constants.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/model/req_model/profile_req_model/profile_model.dart' as update;
import '../../data/model/res_model/profile_details_update_res_model/profile_details_update_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/constants/app_strings.dart';
import '../../ui/utils/club_agent.dart';
import '../../ui/utils/constants/app_urls.dart';
part 'my_app_state.dart';
part 'my_app_event.dart';
part 'my_app_bloc.freezed.dart';

class MyAppBloc extends Bloc<MyAppEvent, MyAppState> {
  MyAppBloc() : super(MyAppState.initial()) {
    on<MyAppEvent>((event, emit) async {
      SharedPreferencesHelper preferences = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
      if (event is _updateProfileDetailsEvent) {
        if (preferences.getAuthToken().isEmpty) {
          return;
        }
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        String version = packageInfo.version;
        update.ProfileModel updatedProfileModel = update.ProfileModel(
          clientDetail: update.ClientDetail(
            deviceType: Platform.isAndroid ? AppStrings.androidString : AppStrings.iosString,
            tokenId: preferences.getFCMToken(),
            lastSeen: DateTime.now(),
            applicationVersion: version,
          ),
        );
        Map<String, dynamic> req = updatedProfileModel.toJson();
        Map<String, dynamic>? clientDetail = updatedProfileModel.clientDetail?.toJson();

        clientDetail?.removeWhere((key, value) {
          if (value != null) {}
          return value == null;
        });

        req[AppStrings.clientDetailString] = clientDetail;
        req.removeWhere((key, value) {
          if (value != null) {}
          return value == null;
        });
        try {
          final res = await DioClient(event.context).post("${AppUrlEndPoints.updateProfileDetailsUrl}/${preferences.getUserId()}", data: req);
          if (res != null) {
            // This runs on every return-from-background, so it is also what keeps the cached
            // club-agent id in step with the management-system setting.
            await preferences.setVeahavtaAgentId(veahavtaAgentId: readVeahavtaAgentId(res));
            ProfileDetailsUpdateResModel response = ProfileDetailsUpdateResModel.fromJson(res);
            if (response.status == AppConstants.code_200) {}
          }
        } catch (_) {}
      }
    });
  }
}
