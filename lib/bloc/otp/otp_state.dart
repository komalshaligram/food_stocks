part of 'otp_bloc.dart';

@freezed

class OtpState with _$OtpState {

  const factory OtpState({
    required int otpTimer,
    required String otp,
    required bool isLoginSuccess,
    required bool isLoginFail,
    required bool isLoading,
    required String errorMessage,
  }) = _OtpState;

  factory OtpState.initial() =>  OtpState(
      otpTimer: 0,
      otp: '',
      isLoginSuccess: false,
      isLoginFail: false,
      isLoading: false,
      errorMessage: '') ;


}




