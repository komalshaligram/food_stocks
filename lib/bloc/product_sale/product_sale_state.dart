part of 'product_sale_bloc.dart';

@freezed
class ProductSaleState with _$ProductSaleState {
  const factory ProductSaleState({
    required List<ProductSale> productSalesList,
    required String search,
    required List<Product> productDetails,
    required List<List<ProductStockModel>> productStockList,
    required bool isShimmering,
    required bool isLoading,
    required bool isProductLoading,
    required int productStockUpdateIndex,
    required int pageNum,
    required bool isLoadMore,
    required bool isBottomOfProducts,
    required bool isSelectSupplier,
    required List<ProductSupplierModel> productSupplierList,
    required int imageIndex,
    required TextEditingController noteController,
    required RefreshController refreshController,
    required bool isGuestUser,
    required List<RelatedProductDatum> relatedProductList,
    required bool isRelatedShimmering,
    required double bottleDeposit,
    required bool isSubUserAddToBasket,
    required bool isGridView,
    required int productListIndex,
    required bool isIncludedVat,
    required bool isSaleOn,

   
  }) = _ProductSaleState;

  factory ProductSaleState.initial() => ProductSaleState(
        productSalesList: [],
        search: '',
        productDetails: [],
        isShimmering: false,
        isLoading: false,
        isProductLoading: false,
        productStockUpdateIndex: -1,
      productStockList: [
        [const ProductStockModel(productId: '')],
        [],
        []
      ],
        pageNum: 0,
        isLoadMore: false,
        isBottomOfProducts: false,
        isSelectSupplier: false,
        productSupplierList: [],
        imageIndex: 0,
        noteController: TextEditingController(),
        refreshController: RefreshController(),
      isGuestUser : false,
    relatedProductList: [],
    isRelatedShimmering: false,
      bottleDeposit:0,
    isSubUserAddToBasket: false,
      isGridView : true,
    productListIndex: -1,
      isIncludedVat : false,
      isSaleOn : false
    
      );
}
