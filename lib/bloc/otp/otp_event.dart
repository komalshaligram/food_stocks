part of 'otp_bloc.dart';

@freezed
class OtpEvent with _$OtpEvent {
  const factory OtpEvent.setOtpTimer({required String contact}) = _setOtpTimerEvent;

  const factory OtpEvent.changeOtpEvent({required String otp}) = _changeOtpEvent;

  const factory OtpEvent.updateOtpTimer() = _UpdateTimerEvent;

  const factory OtpEvent.cancelOtpTimerSubscription() = _cancelTimerscriptionEvent;

  const factory OtpEvent.otpApiEvent({required String contact, required String otp, required bool isRegister, required BuildContext context}) =
      _otpApiEvent;

  const factory OtpEvent.registerApiEvent({required String contact, required String otp, required bool isRegister, required BuildContext context}) =
      _registerApiEvent;

  factory OtpEvent.logInApiDataEvent({required String contactNumber, required BuildContext context, required bool isRegister}) = _logInApiDataEvent;

  factory OtpEvent.sendOtpViaWhatsappEvent({required String contactNumber, required BuildContext context}) = _sendOtpViaWhatsappEvent;

  factory OtpEvent.loadWhatsappOtpSettingEvent({required BuildContext context}) = _loadWhatsappOtpSettingEvent;
}
