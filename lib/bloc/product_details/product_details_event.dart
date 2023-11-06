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
    required int productWeight,
    required int listIndex,
    required BuildContext context
  }) = _productIncrementEvent;

  const factory ProductDetailsEvent.productDecrementEvent({
    required int productWeight,
    required int listIndex,
  }) = _productDecrementEvent;

  const factory ProductDetailsEvent.getProductDataEvent({
    required BuildContext context,
    required int productIndex,
    required String orderId,
  }) = _getProductDataEvent;



}

