part of 'otp_bloc.dart';

@freezed

class OtpState with _$OtpState {

  const factory OtpState({
    required int otpTimer,
    required bool isLoginSuccess,
    required bool isLoginFail,
    required String errorMessage,


  }) = _OtpState;

  factory OtpState.initial() =>  OtpState(
      otpTimer: 0,
    isLoginSuccess: false,
    isLoginFail: false,
    errorMessage: ''
  ) ;


}




