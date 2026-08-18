import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/data/model/res_model/guest_user_login_model/guest_user_login_res_model.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../ui/utils/constants/app_constants.dart';
import '../../ui/utils/constants/app_strings.dart';
import '../../ui/utils/constants/app_urls.dart';
part 'connect_event.dart';
part 'connect_state.dart';
part 'connect_bloc.freezed.dart';

class ConnectBloc extends Bloc<ConnectEvent, ConnectState> {
  ConnectBloc() : super(ConnectState.initial()) {
    on<ConnectEvent>((event, emit) async {
      if (event is _logInAsGuest) {
        if (state.isLoading) return;
        emit(state.copyWith(isLoading: true));

        final preferences = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
        try {
          final res = await DioClient(event.context).post(AppUrlEndPoints.guestLogin);

          if (res == null || res is! Map<String, dynamic>) {
            throw Exception('Network Error');
          }

          printData("check here guest user response $res");
          final response = GuestUserLoginResModel.fromJson(res);
          if (response.status == AppConstants.code_200) {
            await preferences.setIsGuestUser(isGuestUser: true);
            await preferences.setAuthToken(accToken: response.data?.tokenData.accessToken ?? '');
            await preferences.setRefreshToken(refToken: response.data?.tokenData.refreshToken ?? '');
            emit(state.copyWith(isLoading: false));
            if (event.context.mounted) {
              await Navigator.pushNamed(event.context, RouteDefine.bottomNavScreen.name, arguments: {AppStrings.pushNavigationString: 'homeScreen'});
            }
          } else {
            await preferences.setIsGuestUser(isGuestUser: false);
            emit(state.copyWith(isLoading: false));
            if (event.context.mounted) {
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
                  type: SnackBarType.failure);
            }
          }
        } catch (e) {
          await preferences.setIsGuestUser(isGuestUser: false);
          emit(state.copyWith(isLoading: false));
          if (!event.context.mounted) return;
          if (e.toString().contains('Network Error')) {
            return;
          }
          CustomSnackBar.showSnackBar(
              context: event.context, title: AppStrings.getLocalizedStrings(e.toString(), event.context), type: SnackBarType.failure);
        }
      }
    });
  }
}
