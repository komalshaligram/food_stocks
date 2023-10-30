part of 'order_bloc.dart';

@freezed
class OrderEvent with _$OrderEvent {
  const factory OrderEvent.getAllOrderEvent({
    required BuildContext context
}) = _getAllOrderEvent;
}
