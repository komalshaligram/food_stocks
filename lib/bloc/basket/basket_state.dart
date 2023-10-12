part of 'basket_bloc.dart';

@freezed
class BasketState with _$BasketState {

  const factory BasketState({

    required List<ProductDetailsModel>basketProductList,

  }) = _BasketState;

   factory BasketState.initial ()=>BasketState(
     basketProductList: [
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
     ],
);


}
