part of 'privacy_policy_bloc.dart';

@freezed
class PrivacyPolicyState with _$PrivacyPolicyState {
  const factory PrivacyPolicyState({
    required String filePath,
    required Uint8List pdfPath,
    required bool isShimmering,
    required bool isUpdate,
    required bool isOwner2Available,
    required bool isNextEnable,
    required bool isGuarantee1Available,
    required String owner1SignaturePath,
    required String owner2SignaturePath,
    required String guarantee1SignaturePath,
  }) = _PrivacyPolicyState;

  factory PrivacyPolicyState.initial() => PrivacyPolicyState(
    filePath: '',
    isShimmering: false,
    isUpdate: false,
    isOwner2Available: false,
    isNextEnable: false,
    pdfPath: Uint8List(1),
    isGuarantee1Available: false,
    owner1SignaturePath: '',
    owner2SignaturePath: '',
    guarantee1SignaturePath: '',
  );
}