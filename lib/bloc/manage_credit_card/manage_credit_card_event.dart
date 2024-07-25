part of 'manage_credit_card_bloc.dart';



@freezed
class ManageCreditCardEvent with _$ManageCreditCardEvent {
  factory ManageCreditCardEvent.getCreditCardInfoEvent({required BuildContext context}) =
  _getCreditCardInfoEvent;

}