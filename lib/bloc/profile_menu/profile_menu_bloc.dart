import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_menu_event.dart';

part 'profile_menu_state.dart';

part 'profile_menu_bloc.freezed.dart';

class ProfileMenuBloc extends Bloc<ProfileMenuEvent, ProfileMenuState> {
  ProfileMenuBloc() : super(const ProfileMenuState.initial()) {
    on<ProfileMenuEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
