part of 'order_summary_bloc.dart';

@freezed
class OrderSummaryEvent with _$OrderSummaryEvent {

  const factory OrderSummaryEvent.getDataEvent() = _getDataEvent;
}
