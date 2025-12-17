part of 'refund_bloc.dart';

@freezed
class RefundEvent with _$RefundEvent {
  factory RefundEvent.getRefundDataEvent({required BuildContext context}) =_getRefundDataEvent;
  factory RefundEvent.refreshListEvent({required BuildContext context}) = _refreshListEvent;


}