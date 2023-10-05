part of 'order_details_bloc.dart';

@freezed
class OrderDetailsEvent with _$OrderDetailsEvent{
  const factory OrderDetailsEvent.started() = _Started;
}
