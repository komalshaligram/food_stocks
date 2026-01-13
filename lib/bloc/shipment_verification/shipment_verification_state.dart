part of 'shipment_verification_bloc.dart';

@freezed
class ShipmentVerificationState with _$ShipmentVerificationState {
  factory ShipmentVerificationState({
    required bool isSignaturePadActive,
    required bool isDriverSignaturePadActive,
    required bool isLoading,
    required bool isDelete,
    required TextEditingController surfacesController,
    required TextEditingController driverNameController,
  }) = _ShipmentVerificationState;

  factory ShipmentVerificationState.initial() => ShipmentVerificationState(
        isSignaturePadActive: true,
        isDriverSignaturePadActive: true,
        isLoading: false,
        isDelete: false,
        surfacesController: TextEditingController(),
        driverNameController: TextEditingController(),
      );
}
