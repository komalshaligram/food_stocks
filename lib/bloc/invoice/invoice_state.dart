part of 'invoice_bloc.dart';

@freezed
class InvoiceState with _$InvoiceState{

  const factory InvoiceState({
    required List<InvoiceModel>invoiceDetailsList,
  }) = _InvoiceState;

  factory InvoiceState.initial() =>  InvoiceState(
    invoiceDetailsList: [
      InvoiceModel(date: '15/02/24',invoiceNumber: '1548523',invoicePrice: '185625',invoiceState:'pending' ,invoiceType: 'Refund invoice'),
      InvoiceModel(date: '16/02/24',invoiceNumber: '1548523',invoicePrice: '185625',invoiceState:'pending' ,invoiceType: 'Refund invoice'),
      InvoiceModel(date: '17/02/24',invoiceNumber: '1548523',invoicePrice: '185625',invoiceState:'pending' ,invoiceType: 'Refund invoice'),
      InvoiceModel(date: '18/02/24',invoiceNumber: '1548523',invoicePrice: '185625',invoiceState:'pending' ,invoiceType: 'Refund invoice'),
      InvoiceModel(date: '19/02/24',invoiceNumber: '1548523',invoicePrice: '185625',invoiceState:'pending' ,invoiceType: 'Refund invoice'),
      InvoiceModel(date: '20/02/24',invoiceNumber: '1548523',invoicePrice: '185625',invoiceState:'pending' ,invoiceType: 'Refund invoice'),
    ]
  );

}