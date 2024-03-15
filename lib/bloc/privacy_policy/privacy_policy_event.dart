part of 'privacy_policy_bloc.dart';

@freezed
class PrivacyPolicyEvent with _$PrivacyPolicyEvent {
  factory PrivacyPolicyEvent.onFormFieldFocusChangeEvent({required BuildContext context}) =
  _onFormFieldFocusChangeEvent;
  factory PrivacyPolicyEvent.onDocumentLoadedEvent({required BuildContext context}) =
  _onDocumentLoadedEvent;
}