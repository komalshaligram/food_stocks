part of 'company_products_bloc.dart';

@freezed
class CompanyProductsState with _$CompanyProductsState {
  const factory CompanyProductsState({
    required String companyId,
    required List<CompanyDatum> productList,
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
    required bool isGuestUser,
    required bool isGridView,
  }) = _CompanyProductsState;

  factory CompanyProductsState.initial() => CompanyProductsState(
        companyId: '',
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
        isGuestUser : false,
        isGridView: false
      );
}
