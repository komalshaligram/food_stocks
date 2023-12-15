import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'splash_state.dart';
part 'splash_event.dart';
part 'splash_bloc.freezed.dart';


class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashState.initial()) {
    on<SplashEvent>((event, emit) async {
      if(event is _SplashLoadedEvent) {
        await Future.delayed(const Duration(seconds: 1));
        emit(state.copyWith(isAnimate: true));
        await Future.delayed(const Duration(seconds: 2));
        emit(state.copyWith(isRedirected: true));
      }
    });
  }
}