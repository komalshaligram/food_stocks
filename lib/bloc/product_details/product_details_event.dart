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
    required double productWeight,
    required int listIndex,
    required BuildContext context
  }) = _productIncrementEvent;

  const factory ProductDetailsEvent.productDecrementEvent({
    required double productWeight,
    required int listIndex,
  }) = _productDecrementEvent;

  const factory ProductDetailsEvent.getProductDataEvent({
    required BuildContext context,
    required String orderId,
    required OrdersBySupplier orderBySupplierProduct,
  }) = _getProductDataEvent;

  const factory ProductDetailsEvent.createIssueEvent({
    required BuildContext context,
    required String supplierId,
    required String productId,
    required String issue,
    required int missingQuantity,
    required String orderId,
  }) = _createIssueEvent;



}

