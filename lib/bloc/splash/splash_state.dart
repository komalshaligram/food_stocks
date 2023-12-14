part of 'splash_bloc.dart';

@freezed
class SplashState with _$SplashState{

  const factory SplashState({
    required bool isRedirected,
    required bool isAnimate,
  }) = _SplashState;

  factory SplashState.initial()=> const SplashState(
    isRedirected: false,
        isAnimate: false,
      );

}