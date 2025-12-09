part of 'order_summary_bloc.dart';

@freezed
class OrderSummaryEvent with _$OrderSummaryEvent {

  const factory OrderSummaryEvent.getDataEvent({
    required BuildContext context,
    required GetAllCartResModel cartItemList,
    required String totalAmount,
    String? backString,
}) = _getDataEvent;
  const factory OrderSummaryEvent.orderSendEvent({
    required BuildContext context,
    required String paymentMethod,
    required bool failPayment
}) = _orderSendEvent;

  const factory OrderSummaryEvent.payWithBankTransferEvent({required BuildContext context,required bool isFromRemovePopUp}) = _payWithBankTransferEvent;
  const factory OrderSummaryEvent.refreshEvent() = _refreshEvent;
  const factory OrderSummaryEvent.getSupplierPaymentTypeEvent({required BuildContext context, required String id,required int index}) = _getSupplierPaymentTypeEvent;
}
