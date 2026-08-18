part of 'refund_pdf_bloc.dart';

@freezed
class RefundPdfEvent with _$RefundPdfEvent {
  const factory RefundPdfEvent.getArgumentEvent({required RefundInvoiceCommon? invoiceDetailsList, required BuildContext context}) =
      _GetArgumentEvent;

  const factory RefundPdfEvent.verifyInvoiceLink({required BuildContext context}) = _VerifyInvoiceLink;
}
