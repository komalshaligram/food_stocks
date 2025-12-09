part of 'refund_pdf_bloc.dart';

@freezed
class RefundPdfEvent with _$RefundPdfEvent {
  factory RefundPdfEvent.getArgumentEvent({
    required RefundInvoice invoiceDetailsList,
    required BuildContext context,
  }) = _GetArgumentEvent;

  factory RefundPdfEvent.verifyInvoiceLink({
    required BuildContext context,
  }) = _VerifyInvoiceLink;
}
