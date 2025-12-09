part of 'refund_pdf_bloc.dart';

@freezed
class RefundPdfState with _$RefundPdfState {
  const factory RefundPdfState({
    required RefundInvoice invoiceDetailsList,
    required bool isDownloading,
    required int downloadProgress,
    bool? hasValidLink, // null = loading, true = valid, false = invalid
  }) = _RefundPdfState;

  factory RefundPdfState.initial() => const RefundPdfState(
    invoiceDetailsList: RefundInvoice(),
    downloadProgress: 0,
    isDownloading: false,
    hasValidLink: null, // <-- default loading
  );
}
