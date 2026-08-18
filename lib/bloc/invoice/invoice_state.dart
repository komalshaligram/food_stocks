part of 'invoice_bloc.dart';

@freezed
class InvoiceState with _$InvoiceState {
  const factory InvoiceState(
      {required List<Invoice> invoiceDetailsList,
      required bool isShimmering,
      required bool isLoadMore,
      required bool isBottomOfProducts,
      required RefreshController refreshController,
      required int pageNum,
      required List<StatusData> statusList,
      required String language}) = _InvoiceState;

  factory InvoiceState.initial() => InvoiceState(
      invoiceDetailsList: [],
      isShimmering: false,
      isBottomOfProducts: false,
      isLoadMore: false,
      refreshController: RefreshController(),
      pageNum: 0,
      statusList: [],
      language: '');
}
