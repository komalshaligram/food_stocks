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
  }) = _productIncrementEvent;

  const factory ProductDetailsEvent.productDecrementEvent({
    required int productWeight,
    required int listIndex,
  }) = _productDecrementEvent;


}

