part of 'my_accounting_card_bloc.dart';

@freezed
class MyAccountingCardState with _$MyAccountingCardState {
  const factory MyAccountingCardState(
      {required List<MyCardInvoice> invoiceCardList,
      required List<RefundInvoiceCommon> refundInvoicesCardList,
      required bool isShimmering,
      required List<StatusData> statusList,
      required String language,
      required int selectedTabIndex,
      required double clientBalance,
      required double totalInvoiceAmount,
      required double totalRefundAmount,
      required DateTime? invoicesFrom,
      required DateTime? invoicesTo,
      required DateTime? refundsFrom,
      required DateTime? refundsTo,
      DateTime? lastFilterUpdate,
      required ScrollController invoicesScrollController,
      required ScrollController refundsScrollController}) = _MyAccountingCardState;

  factory MyAccountingCardState.initial() => MyAccountingCardState(
      invoiceCardList: const [],
      refundInvoicesCardList: const [],
      isShimmering: false,
      statusList: const [],
      language: '',
      selectedTabIndex: 0,
      clientBalance: 0.0,
      totalInvoiceAmount: 0.0,
      totalRefundAmount: 0.0,
      invoicesFrom: DateTime.now().subtract(const Duration(days: 90)),
      invoicesTo: DateTime.now(),
      refundsFrom: DateTime.now().subtract(const Duration(days: 90)),
      refundsTo: DateTime.now(),
      lastFilterUpdate: null,
      invoicesScrollController: ScrollController(),
      refundsScrollController: ScrollController());
}
