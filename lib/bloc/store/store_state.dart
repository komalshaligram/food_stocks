part of 'store_bloc.dart';

@freezed
class StoreState with _$StoreState {
  const factory StoreState({
    required bool isCategoryExpand,
    required List<Category> productCategoryList,
    required List<ProductSale> productSalesList,
    required List<RecommendationData> recommendedProductsList,
    required List<PreviousOrderProductData> previousOrderProductsList,
    required SuppliersResModel suppliersList,
    required List<Brand> companiesList,
    required List<SearchModel> searchList,
    required bool isShimmering,
    required bool isLoading,
    required bool isProductLoading,
    required List<Product> productDetails,
    required List<ProductStockModel> productStockList,
    required int productStockUpdateIndex,
    required bool isSelectSupplier,
    required List<ProductSupplierModel> productSupplierList,
    required bool isCartCountChange,
    required String search,
    required bool isSearching,
    required int imageIndex,
    required TextEditingController searchController,
    required TextEditingController noteController,
    required RefreshController refreshController,
    required bool isCatVisible,
    required bool isSupplierVisible,
    required bool isCompanyVisible
  }) = _StoreState;

  factory StoreState.initial() => StoreState(
    isCategoryExpand: false,
        productCategoryList: [],
        productSalesList: [],
        recommendedProductsList: [],
        previousOrderProductsList: [],
        suppliersList: SuppliersResModel(),
        companiesList: [],
        searchList: [],
        isShimmering: false,
        isLoading: false,
        isProductLoading: false,
        productDetails: [],
        productStockUpdateIndex: -1,
        productStockList: [ProductStockModel(productId: '')],
        isSelectSupplier: false,
        productSupplierList: [],
        isCartCountChange: false,
        search: '',
        isSearching: false,
        imageIndex: 0,
        searchController: TextEditingController(),
        noteController: TextEditingController(),
        refreshController: RefreshController(),
        isCompanyVisible: true,
        isCatVisible: true,
        isSupplierVisible: true
      );
}
