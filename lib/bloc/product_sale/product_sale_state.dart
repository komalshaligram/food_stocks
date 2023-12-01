part of 'product_sale_bloc.dart';

@freezed
class ProductSaleState with _$ProductSaleState {
  const factory ProductSaleState({
    required List<ProductSale> productSalesList,
    required List<Product> productDetails,
    required List<ProductStockModel> productStockList,
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
  }) = _ProductSaleState;

  factory ProductSaleState.initial() => const ProductSaleState(
        productSalesList: [],
        productDetails: [],
        isShimmering: false,
        isLoading: false,
        isProductLoading: false,
        productStockUpdateIndex: -1,
        productStockList: [],
        pageNum: 0,
        isLoadMore: false,
        isBottomOfProducts: false,
        isSelectSupplier: false,
        productSupplierList: [],
        imageIndex: 0,
      );
}
