part of 'otp_bloc.dart';

@freezed
class OtpEvent with _$OtpEvent {
  const factory OtpEvent.setOtpTimer() = _SetOtpTimerEvent;
  const factory OtpEvent.updateOtpTimer() = _UpdateTimerEvent;
}
