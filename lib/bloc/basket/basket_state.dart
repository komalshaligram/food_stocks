part of 'basket_bloc.dart';

@freezed
class BasketState with _$BasketState {

  const factory BasketState({
    required bool isRefresh,
    required GetAllCartResModel CartItemList,
    required bool isShimmering,
    required int productWeight,
    required List<ProductDetailsModel>basketProductList,
  }) = _BasketState;

   factory BasketState.initial ()=>BasketState(
     isRefresh: false,
     CartItemList: GetAllCartResModel(),
     isShimmering: false,
     productWeight: 0,
       basketProductList : [],
);
}



/*basketProductList: [
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
     ],*/