part of 'privacy_policy_bloc.dart';

@freezed
class PrivacyPolicyState with _$PrivacyPolicyState{

  const factory PrivacyPolicyState({
    required bool SignaturePadDialog,
    required Uint8List documentBytes,
    required File filePath,
    required Uint8List pdfDataBytes

  }) = _PrivacyPolicyState;

  factory PrivacyPolicyState.initial()=>  PrivacyPolicyState(
    SignaturePadDialog: false,
    documentBytes: Uint8List(1),
    filePath: File(''),
    pdfDataBytes: Uint8List(1)

  );

}