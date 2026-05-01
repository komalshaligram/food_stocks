part of 'invoice_payment_bloc.dart';

@freezed
class InvoicePaymentState with _$InvoicePaymentState {
  const factory InvoicePaymentState({required List<StatusData> statusList, required String language, required bool isLoading}) = _InvoicePaymentState;

  factory InvoicePaymentState.initial() => const InvoicePaymentState(statusList: [], language: '', isLoading: false);
}
