part of 'invoice_pdf_bloc.dart';

@freezed
class InvoicePdfState with _$InvoicePdfState{

  const factory InvoicePdfState({
    required InvoiceModel invoiceDetailsList,

  }) = _InvoicePdfState;

  factory InvoicePdfState.initial()=>  InvoicePdfState(
 invoiceDetailsList: InvoiceModel()

  );

}