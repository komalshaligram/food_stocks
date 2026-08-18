part of 'manage_credit_card_bloc.dart';

@freezed
class ManageCreditCardState with _$ManageCreditCardState {
  const factory ManageCreditCardState(
      {required TextEditingController creditCardNumberController,
      required TextEditingController validityController,
      required bool isLoading,
      required bool isCreditCardExist,
      required bool isDeleteLoading}) = _ManageCreditCardState;

  factory ManageCreditCardState.initial() => ManageCreditCardState(
      creditCardNumberController: TextEditingController(),
      validityController: TextEditingController(),
      isLoading: false,
      isCreditCardExist: false,
      isDeleteLoading: false);
}
