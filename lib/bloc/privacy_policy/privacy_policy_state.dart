part of 'privacy_policy_bloc.dart';

@freezed
class PrivacyPolicyState with _$PrivacyPolicyState{

  const factory PrivacyPolicyState({

    required String filePath,
    required bool isShimmering,
    required bool isUpdate,


  }) = _PrivacyPolicyState;

  factory PrivacyPolicyState.initial()=>  PrivacyPolicyState(
    filePath: '',
    isShimmering: false,
    isUpdate: false,


  );

}