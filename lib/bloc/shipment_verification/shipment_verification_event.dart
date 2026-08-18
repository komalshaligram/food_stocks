part of 'shipment_verification_bloc.dart';

@freezed
class ShipmentVerificationEvent with _$ShipmentVerificationEvent {
  factory ShipmentVerificationEvent.signatureEvent() = _signatureEvent;

  factory ShipmentVerificationEvent.driverSignatureEvent() = _driverSignatureEvent;

  factory ShipmentVerificationEvent.deliveryConfirmEvent(
      {required BuildContext context,
      required String supplierId,
      required String signPath,
      required String driverSignPath,
      required String orderId,
      required List<String> driverDeliveryDocumentsImages,
      required List<Map<String, dynamic>> sentReturnData,
      required String? orderIssueReturnId,
      required bool? isFromBasket}) = _deliveryConfirmEvent;

  factory ShipmentVerificationEvent.signDeleteEvent() = _signDeleteEvent;
}
