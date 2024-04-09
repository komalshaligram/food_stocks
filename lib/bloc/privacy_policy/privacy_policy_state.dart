part of 'privacy_policy_bloc.dart';

@freezed
class PrivacyPolicyState with _$PrivacyPolicyState{

  const factory PrivacyPolicyState({
required bool nextEnable,
    required String filePath,
    required bool isShimmering,
    required bool isUpdate,


  }) = _PrivacyPolicyState;

  factory PrivacyPolicyState.initial()=>  PrivacyPolicyState(
    filePath: '',
    isShimmering: false,
    isUpdate: false, nextEnable:false

  );

}