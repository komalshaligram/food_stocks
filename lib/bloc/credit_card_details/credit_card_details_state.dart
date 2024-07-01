part of 'credit_card_details_bloc.dart';

@freezed
class CreditCardDetailsState with _$CreditCardDetailsState{

  const factory CreditCardDetailsState({
    required TextEditingController creditCardNumberController,
    required TextEditingController validityController,
    required bool isLoading,

  }) = _CreditCardDetailsState;

  factory CreditCardDetailsState.initial()=>  CreditCardDetailsState(
   creditCardNumberController: TextEditingController(),
    validityController: TextEditingController(),
    isLoading: false
  );

}