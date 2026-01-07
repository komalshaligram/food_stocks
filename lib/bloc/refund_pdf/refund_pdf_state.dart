part of 'refund_pdf_bloc.dart';

@freezed
class RefundPdfState with _$RefundPdfState {
  const factory RefundPdfState({
    required RefundInvoiceCommon? invoiceDetailsList,
    required bool? hasValidLink,
  }) = _RefundPdfState;

  factory RefundPdfState.initial() => const RefundPdfState(
    invoiceDetailsList: null,
    hasValidLink: null,
  );
}