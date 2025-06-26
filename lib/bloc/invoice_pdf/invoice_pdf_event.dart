part of 'invoice_pdf_bloc.dart';

@freezed
class InvoicePdfEvent with _$InvoicePdfEvent {
  factory InvoicePdfEvent.getArgumentEvent({required  Invoice invoiceDetailsList, required BuildContext context, }) =
  _getArgumentEvent;

  factory InvoicePdfEvent.pdfDownloadEvent({required BuildContext context}) =
  _pdfDownloadEvent;


}