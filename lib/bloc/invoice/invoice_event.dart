part of 'invoice_bloc.dart';

@freezed
class InvoiceEvent with _$InvoiceEvent {
  factory InvoiceEvent.InvoiceLoaded({required String pushNavigation}) =
  _InvoiceLoadedEvent;
}