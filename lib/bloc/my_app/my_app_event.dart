part of 'my_app_bloc.dart';


@freezed
class MyAppEvent with _$MyAppEvent {
  factory MyAppEvent.updateProfileDetailsEvent(
      {required BuildContext context}) = _updateProfileDetailsEvent;

}