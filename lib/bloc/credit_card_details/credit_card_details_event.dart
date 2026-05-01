part of 'credit_card_details_bloc.dart';

@freezed
class CreditCardDetailsEvent with _$CreditCardDetailsEvent {
  factory CreditCardDetailsEvent.getArgumentEvent({
    required bool isPaymentFail,
    required TermsConditionReqModel termsReqModel,
    required bool isFromRegFlow,
    required MyCardInvoice invoiceData,
  }) = _getArgumentEvent;

  factory CreditCardDetailsEvent.addCreditCardEvent({required BuildContext context, required bool isPaymentToNext, required MyCardInvoice invoiceData}) = _addCreditCardEvent;

  factory CreditCardDetailsEvent.termsConditionApiEvent({required BuildContext context, required bool isPaymentToNext}) = _termsConditionApiEvent;

  factory CreditCardDetailsEvent.selectMonthEvent({required String month}) = _selectMonthEvent;
}
