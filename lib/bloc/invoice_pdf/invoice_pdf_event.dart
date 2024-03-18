part of 'invoice_pdf_bloc.dart';

@freezed
class InvoicePdfEvent with _$InvoicePdfEvent {
  factory InvoicePdfEvent.getArgumentEvent({required  InvoiceModel invoiceDetailsList,}) =
  _getArgumentEvent;
}