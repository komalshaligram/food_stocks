part of 'order_refunds_bloc.dart';

@freezed
class OrderRefundsState with _$OrderRefundsState {
  const factory OrderRefundsState({
    required List<RefundInvoiceCommon> invoiceDetailsList,
    required bool isShimmering,
    required bool isBottomOfProducts,
    required RefreshController refreshController,
    required int pageNum,
    required List<StatusData> statusList,
    required String language,
    required String openTotalAmount,
    required int orderNumber,
  }) = _OrderRefundsState;

  factory OrderRefundsState.initial() => OrderRefundsState(
    invoiceDetailsList: [],
    isShimmering: false,
    isBottomOfProducts: false,
    refreshController: RefreshController(),
    pageNum: 0,
    statusList: [],
    language: '',
    openTotalAmount: '',
    orderNumber: 0
  );
}
