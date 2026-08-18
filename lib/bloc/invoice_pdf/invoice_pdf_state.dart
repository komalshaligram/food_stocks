part of 'invoice_pdf_bloc.dart';

@freezed
class InvoicePdfState with _$InvoicePdfState {
  const factory InvoicePdfState(
      {required Invoice invoiceDetailsList,
      required bool isDownloading,
      required int downloadProgress,
      required List<StatusData> statusList,
      bool? hasValidLink}) = _InvoicePdfState;

  factory InvoicePdfState.initial() =>
      const InvoicePdfState(invoiceDetailsList: Invoice(), downloadProgress: 0, isDownloading: false, statusList: <StatusData>[], hasValidLink: null);
}
