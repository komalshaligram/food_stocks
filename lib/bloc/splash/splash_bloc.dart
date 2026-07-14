import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/services/app_version_service.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../ui/utils/constants/app_strings.dart';

part 'splash_state.dart';
part 'splash_event.dart';
part 'splash_bloc.freezed.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashState.initial()) {
    on<SplashEvent>((event, emit) async {
      if (event is _splashLoadedEvent) {
        emit(state.copyWith(pushNavigation: event.pushNavigation));

        final preferences = SharedPreferencesHelper(
            prefs: await SharedPreferences.getInstance());

        await AppVersionService.saveCurrentVersion(preferences);

        final startupArguments = preferences.getUserLoggedIn()
            ? {AppStrings.pushNavigationString: event.pushNavigation}
            : null;

        await Future.delayed(const Duration(seconds: 1));
        emit(state.copyWith(isAnimate: true));

        await Future.delayed(const Duration(seconds: 2));

        emit(state.copyWith(
            isRedirected: true, startupArguments: startupArguments));
      }
    });
  }
}
