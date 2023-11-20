
part of 'order_successful_bloc.dart';

@freezed
class OrderSuccessfulEvent with _$OrderSuccessfulEvent{

  const factory OrderSuccessfulEvent.getWalletRecordEvent({
    required BuildContext context
  }) = _getWalletRecordEvent;

  const factory OrderSuccessfulEvent.getOrderCountEvent({
    required BuildContext context,
  }) = _OrderSuccessfulEvent;



}

