part of 'company_products_bloc.dart';

@freezed
class CompanyProductsState with _$CompanyProductsState {
  const factory CompanyProductsState({
    required String companyId,
    required List<CompanyData> productList,
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
    required int cartCount,
    required bool isCompanyProductGrid,
    required bool isCategoryExpand,
    required bool isSearching,
    required TextEditingController searchController,
    required List<SearchModel> searchList,
    required String search,
    required List<Category> productCategoryList,
    required bool isCatVisible,
    required bool isGridView,
    required bool duringCelebration,


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
       cartCount: 0,
   isCompanyProductGrid : true,
    isCategoryExpand: false,
    isSearching: false,
    searchController: TextEditingController(),
    searchList: [],
    search: '',
    productCategoryList: [],
    isCatVisible: false,
        isGridView: false,
    duringCelebration: false

      );
}
