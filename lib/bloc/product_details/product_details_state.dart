part of 'product_details_bloc.dart';




@freezed
class ProductDetailsState with _$ProductDetailsState {

  const factory ProductDetailsState({
    required bool isCheckBox,
    required bool isProductProblem,

  }) = _ProductDetailsState;

  factory ProductDetailsState.initial()=>  ProductDetailsState(
    isCheckBox: false,
    isProductProblem: false,


  );


}
