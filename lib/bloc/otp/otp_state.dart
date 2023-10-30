part of 'otp_bloc.dart';

@freezed

class OtpState with _$OtpState {

  const factory OtpState({
    required int otpTimer,
    required String otp,
    required bool isLoading,
    required String errorMessage,
    required int codeLength,
  }) = _OtpState;

  factory OtpState.initial() =>  OtpState(
      otpTimer: 0,
      otp: '',
      isLoading: false,
      errorMessage: '',
    codeLength: 0,
  ) ;


}




