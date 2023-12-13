part of 'product_details_bloc.dart';

@freezed
class ProductDetailsState with _$ProductDetailsState {

  const factory ProductDetailsState({
    required bool isProductProblem,
    required bool isRefresh,
    required int selectedRadioTile,
    required List<int>productListIndex,
    required int productWeight,
    required String phoneNumber,
    required OrdersBySupplier orderBySupplierProduct,
    required bool isShimmering,
    required bool isLoading,
    required int quantity,
    required bool isAllCheck,
    required int missingQuantity,
    required String note,
    required TextEditingController addNoteController
  }) = _ProductDetailsState;

  factory ProductDetailsState.initial()=>  ProductDetailsState(

    isProductProblem: false,
    isRefresh: false,
    selectedRadioTile: 0,
  productListIndex: [],
    productWeight: 0,
    phoneNumber: '',
    orderBySupplierProduct: OrdersBySupplier(),
     isShimmering: false,
    isLoading: false,
      quantity: 0,
    isAllCheck: false,
     missingQuantity: 0,
    note: '',
    addNoteController: TextEditingController()


  );
}

/*  productList: [
      ProductDetailsModel(
          productImage: AppImagePath.product3,
          productName: 'Product Name  ',
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
      ),  ProductDetailsModel(
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