part of 'my_accounting_card_bloc.dart';

@freezed
class MyAccountingCardState with _$MyAccountingCardState {
  const factory MyAccountingCardState({
    required List<MyCardRefundInvoice> invoiceCardList,
    required List<RefundInvoiceCommon> refundInvoicesCardList,
    required bool isShimmering,
    required List<StatusData> statusList,
    required String language,
    required int selectedTabIndex,
    required double clientBalance,
    required double totalInvoiceAmount,
    required double totalRefundAmount,
  }) = _MyAccountingCardState;

  factory MyAccountingCardState.initial() => const MyAccountingCardState(
      invoiceCardList: [],
      refundInvoicesCardList: [],
      isShimmering: false,
      statusList: [],
      language: '',
      selectedTabIndex: 0,
      clientBalance: 0.0,
      totalInvoiceAmount : 0.0,
      totalRefundAmount : 0.0
  );
}
