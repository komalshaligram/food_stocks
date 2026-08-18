part of 'credit_card_details_bloc.dart';

@freezed
class CreditCardDetailsState with _$CreditCardDetailsState {
  const factory CreditCardDetailsState(
      {required TextEditingController creditCardNumberController,
      required TextEditingController validityController,
      required bool isLoading,
      required bool isPaymentFail,
      required TermsConditionReqModel termsModel,
      required bool isFromRegFlow,
      required List<String> monthList,
      required String selectedMonth,
      required MyCardInvoice invoiceData}) = _CreditCardDetailsState;

  factory CreditCardDetailsState.initial() => CreditCardDetailsState(
      creditCardNumberController: TextEditingController(),
      validityController: TextEditingController(),
      isLoading: false,
      isPaymentFail: false,
      termsModel: const TermsConditionReqModel(),
      isFromRegFlow: false,
      selectedMonth: '01',
      monthList: ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'],
      invoiceData: const MyCardInvoice());
}
