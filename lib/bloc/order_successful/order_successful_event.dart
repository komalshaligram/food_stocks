
part of 'order_successful_bloc.dart';

@freezed
class OrderSuccessfulEvent with _$OrderSuccessfulEvent{

  const factory OrderSuccessfulEvent.celebrationEvent() = _celebrationEvent;

  const factory OrderSuccessfulEvent.getDataEvent({required BuildContext context, required bool showPreviousBtn}) = _getDataEvent;

}

