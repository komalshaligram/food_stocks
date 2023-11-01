part of 'product_sale_bloc.dart';

@freezed
class ProductSaleState with _$ProductSaleState {
  const factory ProductSaleState({
    required List<Datum> productSalesList,
    required ProductDetailsResModel productDetails,
    required List<ProductStockModel> productStockList,
    required bool isShimmering,
    required bool isLoading,
    required bool isProductLoading,
    required int productStockUpdateIndex,
    required int pageNum,
    required bool isLoadMore,
    required bool isBottomOfProducts,
  }) = _ProductSaleState;

  factory ProductSaleState.initial() => const ProductSaleState(
        productSalesList: [],
        productDetails: ProductDetailsResModel(),
        isShimmering: false,
        isLoading: false,
        isProductLoading: false,
        productStockUpdateIndex: -1,
        productStockList: [],
        pageNum: 0,
        isLoadMore: false,
        isBottomOfProducts: false,
      );
}
