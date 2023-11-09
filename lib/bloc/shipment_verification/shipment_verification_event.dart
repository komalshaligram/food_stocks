part of 'shipment_verification_bloc.dart';

@freezed
class ShipmentVerificationEvent with _$ShipmentVerificationEvent {
  factory ShipmentVerificationEvent.signatureEvent(
) = _signatureEvent;
  factory ShipmentVerificationEvent.deliveryConfirmEvent({
    required BuildContext context,
    required String supplierId,
    required String signPath,
    required String orderId,
}) = _deliveryConfirmEvent;
}


