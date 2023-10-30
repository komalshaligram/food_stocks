import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/storage/shared_preferences_helper.dart';

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
            'getUserImageUrl   ${preferences.getUserImageUrl()}');
        debugPrint(
            'getUserCompanyLogoUrl   ${preferences.getUserCompanyLogoUrl()}');

        emit(state.copyWith(UserImageUrl: preferences.getUserImageUrl()));
        emit(state.copyWith(
            UserCompanyLogoUrl: preferences.getUserCompanyLogoUrl()));
      }
    });
  }
}
