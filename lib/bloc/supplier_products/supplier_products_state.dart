part of 'supplier_products_bloc.dart';

@freezed
class SupplierProductsState with _$SupplierProductsState {
  const factory SupplierProductsState({
    required String supplierId,
    required String search,
    required List<SupplierDatum> productList,
    required bool isShimmering,
    required bool isLoading,
    required bool isProductLoading,
    required List<Product> productDetails,
    required List<ProductStockModel> productStockList,
    required int productStockUpdateIndex,
    required int pageNum,
    required bool isLoadMore,
    required bool isBottomOfProducts,
    required bool isSelectSupplier,
    required List<ProductSupplierModel> productSupplierList,
    required int imageIndex,
    required TextEditingController noteController,
    required RefreshController refreshController,
    required String searchType,
    required bool isGuestUser,
  }) = _SupplierProductsState;

  factory SupplierProductsState.initial() => SupplierProductsState(
    supplierId: '',
        search: '',
        productList: [],
        isShimmering: false,
        isLoading: false,
        isProductLoading: false,
        productDetails: [],
        productStockUpdateIndex: -1,
        productStockList: [],
        pageNum: 0,
        isLoadMore: false,
        isBottomOfProducts: false,
        isSelectSupplier: false,
        productSupplierList: [],
        imageIndex: 0,
        noteController: TextEditingController(),
        refreshController: RefreshController(),
        searchType: '',
      isGuestUser:false,
      );
}
