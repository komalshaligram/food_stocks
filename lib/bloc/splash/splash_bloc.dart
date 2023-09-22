import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'splash_bloc.freezed.dart';

part 'splash_event.dart';

part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  /*SplashBloc(super.initialState);

  SplashState get initialState =>  SplashState.initial();*/

  SplashBloc() : super(SplashState.initial()) {
    on<SplashEvent>((event, emit) async {
      if (event is _SplashLoadedEvent) {
        await Future.delayed(const Duration(seconds: 2));
        emit(state.copyWith(isRedirected: true));
      }
    });
  }

/*  Stream<SplashState> mapEventToState(SplashEvent event) async* {
    print('bloc');

    if (event is SplashLoadedEvent) {

      yield  SplashState.initial();
      try {
        Timer(const Duration(seconds: 1), () {
        });
        yield const SplashState.loaded();
      } catch (_) {
        yield const SplashState.error();
      }
    }
  }*/
}
