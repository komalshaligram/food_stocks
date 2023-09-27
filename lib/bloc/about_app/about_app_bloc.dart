import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'about_app_event.dart';
part 'about_app_state.dart';
part 'about_app_bloc.freezed.dart';

class AboutAppBloc extends Bloc<AboutAppEvent, AboutAppState> {
  AboutAppBloc() : super(const AboutAppState.initial()) {
    on<AboutAppEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
