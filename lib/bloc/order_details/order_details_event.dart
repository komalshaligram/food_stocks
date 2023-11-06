part of 'order_details_bloc.dart';

@freezed
class OrderDetailsEvent with _$OrderDetailsEvent{
  const factory OrderDetailsEvent.getOrderByIdEvent({
    required BuildContext context,
    required String orderId,
}) = _getOrderByIdEvent;
}
