part of 'planogram_product_bloc.dart';

@freezed
class PlanogramProductState with _$PlanogramProductState {
  const factory PlanogramProductState({
    required String planogramName,
    required List<Planogramproduct> planogramProductList,
    required bool isLoading,
    required bool isProductLoading,
    required List<Product> productDetails,
    required List<List<ProductStockModel>> productStockList,
    required int productStockUpdateIndex,
    required bool isSelectSupplier,
    required List<ProductSupplierModel> productSupplierList,
    required bool isCartCountChange,
    required int imageIndex,
    required bool duringCelebration,
    required int cartCount,
    required bool isCategoryExpand,
    required bool isSearching,
    required TextEditingController searchController,
    required List<SearchModel> searchList,
    required String search,
    required List<Category> productCategoryList,
    required bool isCatVisible,
    required bool isGridView,
    required bool isShimmering,
    required List<RelatedProductDatum> relatedProductList,
    required bool isRelatedShimmering,
    required bool isGuestUser,
    required int productListIndex
  }) = _PlanogramProductState;

  factory PlanogramProductState.initial() => PlanogramProductState(
    planogramName: '',
        planogramProductList: [],
        isLoading: false,
        isProductLoading: false,
        productDetails: [],
        productStockUpdateIndex: -1,
      productStockList: [[ProductStockModel(productId: '')],[],[]],
        isSelectSupplier: false,
        productSupplierList: [],
        isCartCountChange: false,
        imageIndex: 0,
    duringCelebration: false,
    cartCount: 0,
    isCategoryExpand: false,
    isSearching: false,
    searchController: TextEditingController(),
    searchList: [],
    search: '',
    productCategoryList: [],
    isCatVisible: false,
    isGridView: true,
    isShimmering: false,
    relatedProductList: [],
    isRelatedShimmering: false,
    isGuestUser: false,
    productListIndex: -1
      );
}
