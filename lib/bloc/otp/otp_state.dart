part of 'otp_bloc.dart';

@freezed
class OtpState with _$OtpState {
  const factory OtpState({
    required int otpTimer,
    required String otp,
    required bool isLoading,
    required String errorMessage,
    required bool isRegister,
    required bool isWhatsappSending,
    required int sendCount,
    required bool showWhatsappOtpOption,
  }) = _OtpState;

  factory OtpState.initial() => const OtpState(
        otpTimer: 0,
        otp: '',
        isLoading: false,
        errorMessage: '',
        isRegister: false,
        isWhatsappSending: false,
        sendCount: 1,
        showWhatsappOtpOption: false,
      );
}
