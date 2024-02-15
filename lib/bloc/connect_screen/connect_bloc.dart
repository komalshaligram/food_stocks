import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/data/storage/shared_preferences_helper.dart';
import 'package:food_stock/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../ui/utils/themes/app_strings.dart';

part 'connect_event.dart';
part 'connect_state.dart';
part 'connect_bloc.freezed.dart';

class ConnectBloc extends Bloc<ConnectEvent, ConnectState> {

  ConnectBloc() : super(ConnectState.initial()) {
    on<ConnectEvent>((event, emit) async {
      SharedPreferencesHelper preferencesHelper =
      SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());

    if (event is _LogInAsGuest) {
        preferencesHelper.setIsGuestUser(isGuestUser: true);
        Navigator.pushNamed(
            event.context, RouteDefine.bottomNavScreen.name,
      arguments: {
      AppStrings.pushNavigationString : 'storeScreen'
      }
      );
      }
    });
  }
}
