part of 'privacy_policy_bloc.dart';

@freezed
class PrivacyPolicyEvent with _$PrivacyPolicyEvent {
  factory PrivacyPolicyEvent.onFormFieldFocusChangeEvent({required BuildContext context , required PdfFormFieldFocusChangeDetails details}) =
  _onFormFieldFocusChangeEvent;
  factory PrivacyPolicyEvent.saveSignatureEvent({required BuildContext context,required PdfSignatureFormField formField}) =
  _saveSignatureEvent;

  factory PrivacyPolicyEvent.navigationEvent({required BuildContext context}) =
  _navigationEvent;
}