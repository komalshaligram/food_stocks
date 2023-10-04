part of 'otp_bloc.dart';

@freezed
class OtpEvent with _$OtpEvent {
  const factory OtpEvent.setOtpTimer() = _SetOtpTimerEvent;
  const factory OtpEvent.updateOtpTimer() = _UpdateTimerEvent;
  const factory OtpEvent.cancelOtpTimerSubscription() = _cancelTimerscriptionEvent;
  const factory OtpEvent.otpApiEvent({
    required String contact,
    required String otp,
    required bool isRegister,
    required BuildContext context,
}) = _otpApiEvent;
}
