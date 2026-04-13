part of 'product_return_info_bloc.dart';

@freezed
class ProductReturnInfoEvent with _$ProductReturnInfoEvent {
  factory ProductReturnInfoEvent.navigateReturnEvent({required BuildContext context}) = _navigateReturnEvent;

  factory ProductReturnInfoEvent.deleteEvent({required BuildContext context}) = _deleteEvent;

  factory ProductReturnInfoEvent.pickDocumentEvent({required BuildContext context, required bool isFromCamera, required int value}) = _pickDocumentEvent;

  factory ProductReturnInfoEvent.deleteFileEvent({required int index, required BuildContext context}) = _deleteFileEvent;

  const factory ProductReturnInfoEvent.productIncrementEvent({required int productQuantity, required BuildContext context}) = _productIncrementEvent;

  const factory ProductReturnInfoEvent.productDecrementEvent({required int productQuantity, required BuildContext context}) = _productDecrementEvent;

  const factory ProductReturnInfoEvent.getArgumentEvent({required Map arguments, required BuildContext context}) = _getArgumentEvent;

  const factory ProductReturnInfoEvent.radioButtonEvent({required int selectRadioTile, required String reason}) = _radioButtonEvent;

  factory ProductReturnInfoEvent.createReturnEvent({required BuildContext context, required String supplierId}) = _createReturnEvent;

  factory ProductReturnInfoEvent.updateReturnEvent({required BuildContext context}) = _updateReturnEvent;

  factory ProductReturnInfoEvent.removeProductEvent({required BuildContext context, required String returnProductId}) = _removeProductEvent;
}
