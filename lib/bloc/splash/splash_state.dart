
part of 'splash_bloc.dart';



@freezed
class SplashState with _$SplashState{
/*  const factory SplashState() = _SplashState;

  const factory SplashState.initial() = _Initial;
  const factory SplashState.error() = _Error;
  const factory SplashState.loaded() = _Loaded;*/

  const factory SplashState({
    required bool isRedirected,
  }) = _SplashState;

  factory SplashState.initial()=> SplashState(
    isRedirected: false,
  );



}
