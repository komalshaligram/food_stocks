part of 'order_summary_bloc.dart';

@freezed
class OrderSummaryState with _$OrderSummaryState {
  const factory OrderSummaryState() = _OrderSummaryState;

  factory OrderSummaryState.initial() => OrderSummaryState();
}
