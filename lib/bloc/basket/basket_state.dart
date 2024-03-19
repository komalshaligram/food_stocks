part of 'basket_bloc.dart';

@freezed
class BasketState with _$BasketState {

  const factory BasketState({
    required GetAllCartResModel CartItemList,
    required bool isShimmering,
    required double productWeight,
    required List<ProductDetailsModel>basketProductList,
    required double totalPayment,
    required bool isLoading,
    required int productImageIndex,
    required String language,
    required int cartCount,
    required bool isRemoveProcess,
    required double vatPercentage,
    required int supplierCount,
    required double bottleTax,
    required int? bottleQty,
    required List<List<ProductStockModel>> productStockList,
    required int productStockUpdateIndex,
    required bool isCartCountChange,
    required List<Product> productDetails,
    required bool isProductLoading,
    required List<ProductSupplierModel> productSupplierList,
    required bool isQtyUpdated,
    required bool isSelectSupplier,
    required List<RelatedProductDatum> relatedProductList,
    required bool isRelatedShimmering,
    required int productListIndex,
    required bool isAnimation,
  }) = _BasketState;

   factory BasketState.initial ()=>BasketState(
     CartItemList: GetAllCartResModel(),
     isShimmering: false,
     productWeight: 0,
       basketProductList : [],
     totalPayment: 0,
     isLoading: false,
       productImageIndex: 0,
     language: 'he',
     cartCount: 0,
     isRemoveProcess: false,
     vatPercentage: 0,
     supplierCount: 1,
     bottleQty: 0,
     bottleTax: 0,
     productStockUpdateIndex: 0,
       productStockList: [[ProductStockModel(productId: '')],[]],
     isCartCountChange: false,
     productDetails: [],
     isProductLoading: false,
     productSupplierList:[],
       isQtyUpdated: false,
     isSelectSupplier: false,
     relatedProductList: [],
     isRelatedShimmering: false,
     productListIndex: -1,
     isAnimation: false
);
}

