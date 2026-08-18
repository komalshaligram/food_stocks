part of 'return_driver_bloc.dart';

@freezed
class ReturnDriverEvent with _$ReturnDriverEvent {
  const factory ReturnDriverEvent.getProductDataEvent(
      {required BuildContext context,
      required String orderId,
      required OrdersBySupplier orderBySupplierProduct,
      required OrderDatum orderData}) = _getProductDataEvent;

  const factory ReturnDriverEvent.checkAllEvent() = _checkAllEvent;

  const factory ReturnDriverEvent.getOrderByIdEvent({required BuildContext context, required String orderId}) = _getOrderByIdEvent;

  const factory ReturnDriverEvent.getDriverReturnIdEvent({required BuildContext context, required String userId}) = _getDriverReturnIdEvent;

  const factory ReturnDriverEvent.getAllCartEvent({required BuildContext context}) = _getAllCartEvent;

  const factory ReturnDriverEvent.getPermissionList({required BuildContext context}) = _getPermissionList;

  factory ReturnDriverEvent.getReturnListEvent({required BuildContext context}) = _getReturnListEvent;

  factory ReturnDriverEvent.pickProofDocumentEvent(
      {required BuildContext context, required bool isFromCamera, required int value, required int index}) = _pickProofDocumentEvent;

  factory ReturnDriverEvent.deleteProofFileEvent({required int index, required BuildContext context, required int fileIndex}) = _deleteProofFileEvent;

  factory ReturnDriverEvent.toggleItemChecked({required int index, required bool isChecked}) = _toggleItemChecked;
}
