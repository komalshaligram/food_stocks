part of 'bank_info_bloc.dart';

@freezed
class BankInfoEvent with _$BankInfoEvent {
  factory BankInfoEvent.selectBankEvent({required String bankName}) = _selectBankEvent;

  factory BankInfoEvent.getBankNameEvent({required BuildContext context}) = _getBankNameEvent;

  factory BankInfoEvent.getTermsConditionModelEvent({required BuildContext context, required TermsConditionReqModel termsConditionReqModel}) = _getTermsConditionModelEvent;

  factory BankInfoEvent.termsConditionApiEvent({required BuildContext context}) = _termsConditionApiEvent;

  factory BankInfoEvent.getArgumentEvent({required bool isPaymentFail, required bool isUpdate}) = _getArgumentEvent;

  factory BankInfoEvent.addBankInfoEvent({required BuildContext context}) = _addBankInfoEvent;
}
