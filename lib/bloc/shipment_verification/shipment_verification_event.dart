part of 'shipment_verification_bloc.dart';

@freezed
class ShipmentVerificationEvent with _$ShipmentVerificationEvent {
  factory ShipmentVerificationEvent.signatureEvent() = _signatureEvent;
}


