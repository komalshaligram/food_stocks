part of 'privacy_policy_bloc.dart';

@freezed
class PrivacyPolicyState with _$PrivacyPolicyState{

  const factory PrivacyPolicyState({
    required bool SignaturePadDialog,
    required Uint8List documentBytes,
    required String filePath,
    required Uint8List pdfDataBytes,
    required File fileData,
    required bool isShimmering,
    required bool isAbsorbing,

  }) = _PrivacyPolicyState;

  factory PrivacyPolicyState.initial()=>  PrivacyPolicyState(
    SignaturePadDialog: false,
    documentBytes: Uint8List(1),
    filePath: '',
    pdfDataBytes: Uint8List(1),
    fileData: File(''),
    isShimmering: false,
    isAbsorbing: false,

  );

}