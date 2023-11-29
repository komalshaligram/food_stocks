part of 'order_summary_bloc.dart';

@freezed
class OrderSummaryEvent with _$OrderSummaryEvent {

  const factory OrderSummaryEvent.getDataEvent({
    required BuildContext context
}) = _getDataEvent;
  const factory OrderSummaryEvent.orderSendEvent({
    required BuildContext context,
    required bool isEnable,
}) = _orderSendEvent;
}
