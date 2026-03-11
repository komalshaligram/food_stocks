part of 'registration_success_bloc.dart';

@freezed
class RegistrationSuccessState with _$RegistrationSuccessState {
  const factory RegistrationSuccessState({
    required bool duringCelebration,
    required String registrationSuccessMessage,
  }) = _RegistrationSuccessState;

  factory RegistrationSuccessState.initial() => const RegistrationSuccessState(
        duringCelebration: true,
        registrationSuccessMessage: '',
      );
}
