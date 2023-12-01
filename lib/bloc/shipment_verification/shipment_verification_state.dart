part of 'shipment_verification_bloc.dart';

@freezed
class ShipmentVerificationState with _$ShipmentVerificationState{

   factory ShipmentVerificationState({
    required bool isSignaturePadActive,
     required bool isLoading,
}) = _ShipmentVerificationState;

  factory ShipmentVerificationState.initial()=>  ShipmentVerificationState(
 isSignaturePadActive: false,
    isLoading: false,

  );

}