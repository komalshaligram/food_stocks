part of 'connect_bloc.dart';


@freezed
class ConnectEvent with _$ConnectEvent {


  factory ConnectEvent.logInAsGuest({
    required BuildContext context,
  }) = _LogInAsGuest;
}