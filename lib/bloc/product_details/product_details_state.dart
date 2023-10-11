part of 'product_details_bloc.dart';




@freezed
class ProductDetailsState with _$ProductDetailsState {

  const factory ProductDetailsState({
    required bool isCheckBox,
    required bool isProductProblem,
    required List<ProductDetailsModel>productList,

  }) = _ProductDetailsState;

  factory ProductDetailsState.initial()=>  ProductDetailsState(
    isCheckBox: false,
    isProductProblem: false,
    productList: [
      ProductDetailsModel(
          productImage: AppImagePath.product3,
          productName: 'Tomato',
          productPrice: 12 ,
          productWeight: 20 ,
      ),
      ProductDetailsModel(
        productImage: AppImagePath.product3,
        productName: 'Tomato',
        productPrice: 12 ,
        productWeight: 20 ,
      ),
      ProductDetailsModel(
        productImage: AppImagePath.product3,
        productName: 'Tomato',
        productPrice: 12 ,
        productWeight: 20 ,
      ),
      ProductDetailsModel(
        productImage: AppImagePath.product3,
        productName: 'Tomato',
        productPrice: 12 ,
        productWeight: 20 ,
      ),
      ProductDetailsModel(
        productImage: AppImagePath.product3,
        productName: 'Tomato',
        productPrice: 12 ,
        productWeight: 20 ,
      ),
      ProductDetailsModel(
        productImage: AppImagePath.product3,
        productName: 'Tomato',
        productPrice: 12 ,
        productWeight: 20 ,
      ),
    ],
  );
}
