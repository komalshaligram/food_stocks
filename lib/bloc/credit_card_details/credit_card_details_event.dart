part of 'credit_card_details_bloc.dart';

@freezed
class CreditCardDetailsEvent with _$CreditCardDetailsEvent {
  factory CreditCardDetailsEvent.getArgumentEvent({required bool isPaymentFail,required TermsConditionReqModel termsReqModel}) =
  _getArgumentEvent;
  factory CreditCardDetailsEvent.addCreditCardEvent({required BuildContext context}) =
  _addCreditCardEvent;
  factory CreditCardDetailsEvent.termsConditionApiEvent({required BuildContext context}) =
  _termsConditionApiEvent;

}