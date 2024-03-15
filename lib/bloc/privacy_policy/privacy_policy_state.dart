part of 'privacy_policy_bloc.dart';

@freezed
class PrivacyPolicyState with _$PrivacyPolicyState{

  const factory PrivacyPolicyState({
    required bool SignaturePadDialog,

  }) = _PrivacyPolicyState;

  factory PrivacyPolicyState.initial()=> const PrivacyPolicyState(
    SignaturePadDialog: false

  );

}