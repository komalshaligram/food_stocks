part of 'order_refunds_bloc.dart';

@freezed
class OrderRefundsEvent with _$OrderRefundsEvent {
  factory OrderRefundsEvent.getRefundDataEvent({required BuildContext context}) =_getRefundDataEvent;
  factory OrderRefundsEvent.refreshListEvent({required BuildContext context}) = _refreshListEvent;


}