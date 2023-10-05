part of 'product_details_bloc.dart';

@freezed
class ProductDetailsEvent with _$ProductDetailsEvent{

  const factory ProductDetailsEvent.checkBoxEvent({
    required bool isCheckBox,
    required int index,
}) = _checkBoxEvent;

  const factory ProductDetailsEvent.productProblemEvent({
    required bool isProductProblem,
    required int index,
  }) = _productProblemEvent;


}

