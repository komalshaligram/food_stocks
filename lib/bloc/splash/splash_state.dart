part of 'splash_bloc.dart';

@freezed
class SplashState with _$SplashState{

  const factory SplashState({
    required bool isRedirected,
  }) = _SplashState;

  factory SplashState.initial()=> const SplashState(
    isRedirected: false,
  );

}