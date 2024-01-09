part of 'product_details_bloc.dart';

@freezed
class ProductDetailsEvent with _$ProductDetailsEvent{


  const factory ProductDetailsEvent.productProblemEvent({
    required bool isProductProblem,
    required int index,
  }) = _productProblemEvent;

  const factory ProductDetailsEvent.radioButtonEvent({
    required int selectRadioTile,
  }) = _radioButtonEvent;

  const factory ProductDetailsEvent.productIncrementEvent({
    required int productQuantity,
    required int listIndex,
    required BuildContext context,
    required int messingQuantity,

  }) = _productIncrementEvent;

  const factory ProductDetailsEvent.productDecrementEvent({
    required int productQuantity,
    required int listIndex,
    required int messingQuantity,
    required BuildContext context,
  }) = _productDecrementEvent;

  const factory ProductDetailsEvent.getProductDataEvent({
    required BuildContext context,
    required String orderId,
    required OrdersBySupplier orderBySupplierProduct,
  }) = _getProductDataEvent;

  const factory ProductDetailsEvent.createIssueEvent({
    required BuildContext BottomSheetContext,
    required BuildContext context,
    required String supplierId,
    required String productId,
    required String issue,
    required int missingQuantity,
    required String orderId,
    required bool isDeliver
  }) = _createIssueEvent;

  const factory ProductDetailsEvent.checkAllEvent(
  ) = _checkAllEvent;

  const factory ProductDetailsEvent.getOrderByIdEvent({
    required BuildContext context,
    required String orderId,
  }) = _getOrderByIdEvent;

  const factory ProductDetailsEvent.getBottomSheetDataEvent({
    required String note,
  }) = _getBottomSheetDataEvent;
}

