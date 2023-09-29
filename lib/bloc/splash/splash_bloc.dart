import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'splash_bloc.freezed.dart';
part 'splash_event.dart';
part 'splash_state.dart';


class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc(super.initialState);

  SplashState get initialState => SplashState.initial();

  Stream<SplashState> mapEventToState(SplashEvent event) async* {
    if (event is SplashLoadedEvent) {
      yield SplashState.initial();
      try {
        Timer(const Duration(seconds: 8), () {

        });
        yield SplashState.loaded();
      } catch (_) {
        yield SplashState.error();
      }
    }
  }
}