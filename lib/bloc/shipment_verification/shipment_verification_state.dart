part of 'shipment_verification_bloc.dart';

@freezed
class ShipmentVerificationState with _$ShipmentVerificationState{

   factory ShipmentVerificationState({
    required bool isSignaturePad,
}) = _ShipmentVerificationState;

  factory ShipmentVerificationState.initial()=>  ShipmentVerificationState(
 isSignaturePad: false,

  );

}