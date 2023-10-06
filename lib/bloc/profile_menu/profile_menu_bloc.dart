import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/storage/shared_preferences_helper.dart';

part 'profile_menu_event.dart';

part 'profile_menu_state.dart';

part 'profile_menu_bloc.freezed.dart';

class ProfileMenuBloc extends Bloc<ProfileMenuEvent, ProfileMenuState> {
  ProfileMenuBloc() : super(ProfileMenuState.initial()) {
    on<ProfileMenuEvent>((event, emit) async {
      if(event is _getPreferenceDataEvent){
        SharedPreferencesHelper preferences = SharedPreferencesHelper(
            prefs: await SharedPreferences.getInstance());

      emit(state.copyWith(UserImageUrl: preferences.getUserImageUrl()));
      emit(state.copyWith(UserCompanyLogoUrl: preferences.getUserCompanyLogoUrl()));
      emit(state.copyWith(userName: preferences.getUserName()));
    }
    });
  }
}
