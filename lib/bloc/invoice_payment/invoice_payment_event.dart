part of 'invoice_payment_bloc.dart';

@freezed
class InvoicePaymentEvent with _$InvoicePaymentEvent {
  factory InvoicePaymentEvent.getStatusDataEvent({required BuildContext context}) = _getStatusDataEvent;

  factory InvoicePaymentEvent.addCreditCardEvent(
      {required BuildContext context,
      required int invoiceNumber,
      required String orderId,
      required String supplierId,
      required int documentType}) = _addCreditCardEvent;
}
