
part of 'order_successful_bloc.dart';

@freezed
class OrderSuccessfulEvent with _$OrderSuccessfulEvent{

  const factory OrderSuccessfulEvent.celebrationEvent() = _celebrationEvent;

  const factory OrderSuccessfulEvent.getDataEvent({required BuildContext context, required bool showPreviousBtn, int? totalSupplier,
    }) = _getDataEvent;

  const factory OrderSuccessfulEvent.getAllCartEvent({required BuildContext context} ) = _getAllCartEvent;

  const factory OrderSuccessfulEvent.generalSettings({required BuildContext context, }) = _generalSettings;

  const factory OrderSuccessfulEvent.goToOrderEvent({required BuildContext context} ) = _goToOrderEvent;

}

