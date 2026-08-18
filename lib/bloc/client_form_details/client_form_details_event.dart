part of 'client_form_details_bloc.dart';

@freezed
class ClientFormDetailsEvent with _$ClientFormDetailsEvent {
  const factory ClientFormDetailsEvent.started() = _Started;

  factory ClientFormDetailsEvent.selectAgentEvent({required String agent}) = _selectAgentEvent;

  factory ClientFormDetailsEvent.selectBusinessTypeEvent({required String business, required bool haveMultiple}) = _selectBusinessTypeEvent;

  factory ClientFormDetailsEvent.getAgentEvent({required BuildContext context}) = _getAgentEvent;

  factory ClientFormDetailsEvent.getBusinessTypeEvent({required BuildContext context}) = _getBusinessTypeEvent;

  factory ClientFormDetailsEvent.verifyAgentEvent({required BuildContext context}) = _verifyAgentEvent;

  factory ClientFormDetailsEvent.selectOwnerNoEvent({required String owner}) = _selectOwnerNoEvent;

  factory ClientFormDetailsEvent.getArgumentEvent({required String owner, required String businessTypeId, required bool isFreelancer}) =
      _getArgumentEvent;

  factory ClientFormDetailsEvent.selectBankEvent({required String bankId, required String bankName}) = _selectBankEvent;

  factory ClientFormDetailsEvent.getBankNameEvent({required BuildContext context}) = _getBankNameEvent;

  factory ClientFormDetailsEvent.onFormFieldFocusChangeEvent({required BuildContext context, required PdfFormFieldFocusChangeDetails details}) =
      _onFormFieldFocusChangeEvent;

  factory ClientFormDetailsEvent.saveSignatureEvent({required BuildContext context, required PdfSignatureFormField formField}) = _saveSignatureEvent;

  factory ClientFormDetailsEvent.getPdfDataEvent(
      {required BuildContext context, required String pdfData, required TermsConditionReqModel termsConditionReqModel}) = _getPdfDataEvent;

  factory ClientFormDetailsEvent.signatureEvent({required BuildContext context, required String fieldName, required String fieldNameForSign}) =
      _signatureEvent;

  factory ClientFormDetailsEvent.uploadSignatureFromPadEvent(
      {required BuildContext context, required String fieldName, required String localImagePath}) = _uploadSignatureFromPadEvent;

  factory ClientFormDetailsEvent.updateClientDataEvent({required BuildContext context}) = _updateClientDataEvent;

  factory ClientFormDetailsEvent.deleteFileEvent({required BuildContext context, required String fieldName}) = _deleteFileEvent;

  const factory ClientFormDetailsEvent.getProfileDetailsEvent({required BuildContext context}) = _getProfileDetailsEvent;
}
