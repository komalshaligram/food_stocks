part of 'credit_card_details_bloc.dart';

@freezed
class CreditCardDetailsEvent with _$CreditCardDetailsEvent {
  factory CreditCardDetailsEvent.getArgumentEvent({
    required bool isPaymentFail,
    required TermsConditionReqModel termsReqModel,
    required bool isFromRegFlow,
  }) = _getArgumentEvent;

  factory CreditCardDetailsEvent.addCreditCardEvent({
    required BuildContext context,
  }) = _addCreditCardEvent;

  factory CreditCardDetailsEvent.termsConditionApiEvent({
    required BuildContext context,
  }) = _termsConditionApiEvent;

  factory CreditCardDetailsEvent.selectMonthEvent({
    required String month,
  }) = _selectMonthEvent;
}
