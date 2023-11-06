part of 'supplier_products_bloc.dart';

@freezed
class SupplierProductsState with _$SupplierProductsState {
  const factory SupplierProductsState({
    required String supplierId,
    required List<Datum> productList,
    required bool isShimmering,
    required bool isLoading,
    required bool isProductLoading,
    required ProductDetailsResModel productDetails,
    required List<ProductStockModel> productStockList,
    required int productStockUpdateIndex,
    required int pageNum,
    required bool isLoadMore,
    required bool isBottomOfProducts,
  }) = _SupplierProductsState;

  factory SupplierProductsState.initial() => SupplierProductsState(
        supplierId: '',
        productList: [],
        isShimmering: false,
        isLoading: false,
        isProductLoading: false,
        productDetails: ProductDetailsResModel(),
        productStockUpdateIndex: -1,
        productStockList: [],
        pageNum: 0,
        isLoadMore: false,
        isBottomOfProducts: false,
      );
}
