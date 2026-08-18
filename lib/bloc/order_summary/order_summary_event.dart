part of 'order_summary_bloc.dart';

@freezed
class OrderSummaryEvent with _$OrderSummaryEvent {
  const factory OrderSummaryEvent.getDataEvent(
      {required BuildContext context, required GetAllCartResModel cartItemList, required String totalAmount, String? backString}) = _getDataEvent;
}
