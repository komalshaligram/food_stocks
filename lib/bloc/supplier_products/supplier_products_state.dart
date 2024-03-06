part of 'supplier_products_bloc.dart';

@freezed
class SupplierProductsState with _$SupplierProductsState {
  const factory SupplierProductsState({
    required String supplierId,
    required String search,
    required List<SupplierProductsData> productList,
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
    required bool isGridView,
    required bool isCategoryExpand,
    required bool isSearching,
    required TextEditingController searchController,
    required List<SearchModel> searchList,
    required List<Category> productCategoryList,
    required bool isCatVisible,
    required List<RelatedProductDatum> relatedProductList,
    required bool isRelatedShimmering,
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
        productStockList: [ProductStockModel(productId: '')],
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
     isGridView :false,
    isCategoryExpand: false,
    isSearching: false,
    searchController: TextEditingController(),
    searchList: [],
    productCategoryList: [],
    isCatVisible: false,
    relatedProductList: [],
    isRelatedShimmering: false,

      );
}
