part of 'product_details_bloc.dart';

@freezed
class ProductDetailsState with _$ProductDetailsState {

  const factory ProductDetailsState({
    required bool isProductProblem,
    required List<ProductDetailsModel>productList,
    required bool isRefresh,
    required int selectedRadioTile,

  }) = _ProductDetailsState;

  factory ProductDetailsState.initial()=>  ProductDetailsState(

    isProductProblem: false,
    isRefresh: false,
    selectedRadioTile: 0,
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
