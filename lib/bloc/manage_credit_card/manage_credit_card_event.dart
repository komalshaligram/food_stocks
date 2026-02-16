part of 'manage_credit_card_bloc.dart';

@freezed
class ManageCreditCardEvent with _$ManageCreditCardEvent {
  factory ManageCreditCardEvent.getCreditCardInfoEvent({
    required BuildContext context,
  }) = _getCreditCardInfoEvent;

  factory ManageCreditCardEvent.addCreditCardEvent({
    required BuildContext context,
  }) = _addCreditCardEvent;

  factory ManageCreditCardEvent.deleteCreditCardEvent({
    required BuildContext context,
  }) = _deleteCreditCardEvent;
}
