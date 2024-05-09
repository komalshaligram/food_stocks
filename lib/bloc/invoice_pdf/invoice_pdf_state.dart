part of 'invoice_pdf_bloc.dart';

@freezed
class InvoicePdfState with _$InvoicePdfState{

  const factory InvoicePdfState({
    required Invoice invoiceDetailsList,
    required bool isDownloading,
    required int downloadProgress,
  }) = _InvoicePdfState;

  factory InvoicePdfState.initial()=>  InvoicePdfState(
 invoiceDetailsList: Invoice(),
    downloadProgress: 0,
    isDownloading: false,
  );

}