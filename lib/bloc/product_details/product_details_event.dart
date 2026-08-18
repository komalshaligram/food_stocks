part of 'product_details_bloc.dart';

@freezed
class ProductDetailsEvent with _$ProductDetailsEvent {
  const factory ProductDetailsEvent.productProblemEvent({required bool isProductProblem, required int index}) = _productProblemEvent;

  const factory ProductDetailsEvent.radioButtonEvent({required int selectRadioTile}) = _radioButtonEvent;

  const factory ProductDetailsEvent.productIncrementEvent(
      {required int productQuantity,
      required int listIndex,
      required BuildContext context,
      required int messingQuantity,
      required int radioValue,
      required Map<int, Map<String, dynamic>> productIssueData}) = _productIncrementEvent;

  const factory ProductDetailsEvent.productDecrementEvent(
      {required int productQuantity,
      required int listIndex,
      required int messingQuantity,
      required BuildContext context,
      required int radioValue,
      required Map<int, Map<String, dynamic>> productIssueData}) = _productDecrementEvent;

  const factory ProductDetailsEvent.getProductDataEvent(
      {required BuildContext context,
      required String orderId,
      required OrdersBySupplier orderBySupplierProduct,
      required OrderDatum orderData,
      required List<StatusData> statusList}) = _getProductDataEvent;

  const factory ProductDetailsEvent.checkAllEvent() = _checkAllEvent;

  const factory ProductDetailsEvent.getOrderByIdEvent({required BuildContext context, required String orderId}) = _getOrderByIdEvent;

  const factory ProductDetailsEvent.getBottomSheetDataEvent({required BuildContext context, required String notes}) = _getBottomSheetDataEvent;

  const factory ProductDetailsEvent.duplicateOrderEvent(
      {required BuildContext context, required String orderId, required BuildContext dialogContext}) = _duplicateOrderEvent;

  const factory ProductDetailsEvent.getAllCartEvent({required BuildContext context}) = _getAllCartEvent;

  const factory ProductDetailsEvent.getPermissionList({required BuildContext context}) = _getPermissionList;

  factory ProductDetailsEvent.pickDocumentEvent(
      {required BuildContext context,
      required bool isFromCamera,
      required int value,
      required Map<int, Map<String, dynamic>> productIssueData,
      required int selectedRadio}) = _pickDocumentEvent;

  factory ProductDetailsEvent.getPickDocumentEvent({required BuildContext context, required List<String>? proofImages}) = _getPickDocumentEvent;

  factory ProductDetailsEvent.deleteFileEvent(
      {required int index,
      required BuildContext context,
      required Map<int, Map<String, dynamic>> productIssueData,
      required int selectedRadio}) = _deleteFileEvent;

  factory ProductDetailsEvent.createReturnEvent(
      {required BuildContext context,
      required BuildContext bottomSheetContext,
      required String supplierId,
      required String productId,
      required int totalRefund,
      List<String>? proofImages,
      required String notes,
      required String productName,
      required String productImage,
      required String barcode,
      required int totalUnits,
      required bool isApproved,
      required String reasonToReturn,
      String? orderId}) = _createReturnEvent;

  factory ProductDetailsEvent.updateReturnEvent(
      {required BuildContext context,
      required BuildContext bottomSheetContext,
      required String supplierId,
      required String productId,
      required int totalRefund,
      List<String>? proofImages,
      required String notes,
      required String productName,
      required String productImage,
      required String barcode,
      required int totalUnits,
      required bool isApproved,
      required String reasonToReturn,
      String? orderId,
      required List<ReturnProduct> returnProduct,
      String? returnProductId,
      required bool isRemoved}) = _updateReturnEvent;

  factory ProductDetailsEvent.getReturnListEvent({required BuildContext context, List<String>? excludeBarcodes}) = _getReturnListEvent;

  const factory ProductDetailsEvent.getArgumentEvent({required dynamic arguments, required BuildContext context, required int productQuantity}) =
      _getArgumentEvent;

  factory ProductDetailsEvent.deleteEvent(
      {required BuildContext context,
      required BuildContext bottomSheetContext,
      required String reasonToReturn,
      required String barcode,
      String? returnId,
      required OrdersBySupplier orderSupplierProduct}) = _deleteEvent;

  factory ProductDetailsEvent.pickProofDocumentEvent({required BuildContext context, required bool isFromCamera, required int value}) =
      _pickProofDocumentEvent;

  factory ProductDetailsEvent.deleteProofFileEvent({required int index, required BuildContext context}) = _deleteProofFileEvent;
}
