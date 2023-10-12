import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/storage/shared_preferences_helper.dart';
import '../../ui/utils/themes/app_urls.dart';

part 'home_event.dart';
part 'home_state.dart';
part 'home_bloc.freezed.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super( HomeState.initial()) {
    on<HomeEvent>((event, emit) async {
      if(event is _getPreferencesDataEvent){
        SharedPreferencesHelper preferences = SharedPreferencesHelper(
            prefs: await SharedPreferences.getInstance());

        debugPrint(
            'getUserImageUrl______${AppUrls.baseFileUrl}${preferences.getUserImageUrl()}');
        debugPrint(
            'getUserCompanyLogoUrl______${preferences.getUserCompanyLogoUrl()}');

        emit(state.copyWith(UserImageUrl: preferences.getUserImageUrl()));
        emit(state.copyWith(
            UserCompanyLogoUrl: preferences.getUserCompanyLogoUrl()));
      }
    });
  }
}
