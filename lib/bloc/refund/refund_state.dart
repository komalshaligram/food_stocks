part of 'refund_bloc.dart';

@freezed
class RefundState with _$RefundState {
  const factory RefundState({
    required List<RefundInvoiceCommon> invoiceDetailsList,
    required bool isShimmering,
    required bool isBottomOfProducts,
    required RefreshController refreshController,
    required int pageNum,
    required List<StatusData> statusList,
    required String language,
    required String openTotalAmount,
  }) = _RefundState;

  factory RefundState.initial() => RefundState(
        invoiceDetailsList: [],
        isShimmering: false,
        isBottomOfProducts: false,
        refreshController: RefreshController(),
        pageNum: 0,
        statusList: [],
        language: '',
        openTotalAmount: '',
      );
}
