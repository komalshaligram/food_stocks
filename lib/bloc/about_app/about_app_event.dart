part of 'about_app_bloc.dart';

@freezed
class AboutAppEvent with _$AboutAppEvent {
  const factory AboutAppEvent.started() = _Started;
}
