part of 'credit_card_details_bloc.dart';

@freezed
class CreditCardDetailsEvent with _$CreditCardDetailsEvent {
  factory CreditCardDetailsEvent.getArgumentEvent({required bool isPaymentFail}) =
  _getArgumentEvent;
}