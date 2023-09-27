part of 'otp_bloc.dart';

@freezed
class OtpState with _$OtpState {

  const factory OtpState({required bool isOtpTimerVisible, required int otpTimer}) = _Initial;

  factory OtpState.initial() => const OtpState(isOtpTimerVisible: false, otpTimer: 0) ;
}
