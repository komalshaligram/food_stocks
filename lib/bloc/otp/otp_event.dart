part of 'otp_bloc.dart';

@freezed
class OtpEvent with _$OtpEvent {
  const factory OtpEvent.setOtpTimer() = _SetOtpTimerEvent;

  const factory OtpEvent.changeOtpEvent({required String otp}) =
      _ChangeOtpEvent;

  const factory OtpEvent.updateOtpTimer() = _UpdateTimerEvent;
  const factory OtpEvent.cancelOtpTimerSubscription() = _cancelTimerscriptionEvent;
  const factory OtpEvent.otpApiEvent({
    required String contact,
    required String otp,
    required bool isRegister,
    required BuildContext context,
}) = _otpApiEvent;

  const factory OtpEvent.registerApiEvent({
    required String contact,
    required String otp,
    required bool isRegister,
    required BuildContext context,
  }) = _registerApiEvent;

  factory OtpEvent.logInApiDataEvent({
    required String contactNumber,
    required BuildContext context,
    required bool isRegister,
  }) = _logInApiDataEvent;

}
