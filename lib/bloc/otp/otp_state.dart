part of 'otp_bloc.dart';

@freezed
class OtpState with _$OtpState {

  const factory OtpState({required int otpTimer}) = _Initial;

  factory OtpState.initial() => const OtpState(otpTimer: 0) ;
}
