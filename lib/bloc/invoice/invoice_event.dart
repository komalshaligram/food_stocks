part of 'invoice_bloc.dart';

@freezed
class InvoiceEvent with _$InvoiceEvent {
  factory InvoiceEvent.getInvoicesDataEvent({required BuildContext context}) =_getInvoicesDataEvent;
  factory InvoiceEvent.refreshListEvent({required BuildContext context}) = _refreshListEvent;


}