part of 'splash_bloc.dart';

@freezed
class SplashEvent with _$SplashEvent {
    factory SplashEvent.splashLoaded() = _SplashLoadedEvent;
}