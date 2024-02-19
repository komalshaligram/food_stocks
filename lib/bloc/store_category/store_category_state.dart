part of 'store_category_bloc.dart';

@freezed
class StoreCategoryState with _$StoreCategoryState {
  const factory StoreCategoryState({
    required bool isCategoryExpand,
    required bool isSubCategory,
    required String categoryId,
    required String subCategoryId,
    required String categoryName,
    required String subCategoryName,
    required List<SubCategory> subCategoryList,
    required List<PlanogramDatum> planoGramsList,
    required List<PlanogramDatum> subPlanoGramsList,
    required List<PlanogramProduct> planoGramsByIdList,
    required List<Category> productCategoryList,
    required List<List<ProductStockModel>> productStockList,
    required bool isPlanogramShimmering,
    required bool isSubCategoryShimmering,
    required bool isLoading,
    required bool isProductLoading,
    required int planogramPageNum,
    required int subProductPageNum,
    required int subPlanogramPageNum,
    required int subCategoryPageNum,
    required bool isLoadMore,
    required bool isBottomOfPlanoGrams,
    required bool isBottomOfSubCategory,
    required List<Product> productDetails,
    required int planoGramUpdateIndex,
    required int productStockUpdateIndex,
    required bool isSelectSupplier,
    required List<ProductSupplierModel> productSupplierList,
    required List<SearchModel> searchList,
    required String search,
    required bool isSearching,
    required int imageIndex,
    required TextEditingController searchController,
    required TextEditingController noteController,
    required RefreshController subCategoryRefreshController,
    required RefreshController planogramRefreshController,
    required List<PlanogramAllProduct> planogramProductList,
    required List<Planogramproduct> categoryPlanogramList,
    required List<Planogramproduct> subCategoryPlanogramList,
    required List<PlanogramDatum> subCatPlanoGramsList,
    required bool isBottomOfProducts,
    required bool isPlanogramProductShimmering,
    required bool isGridView,
    required bool isGuestUser,
    required bool isBottomProducts,
    required int cartCount,
    required bool duringCelebration,
  }) = _StoreCategoryState;

  factory StoreCategoryState.initial() => StoreCategoryState(
        isCategoryExpand: false,
        isSubCategory: true,
        categoryId: '',
        subCategoryId: '',
        categoryName: '',
        subCategoryName: '',
        subCategoryList: [],
        productCategoryList: [],
        planoGramsList: [],
        productStockList: [],
        isPlanogramShimmering: false,
        isSubCategoryShimmering: false,
        isLoading: false,
        isProductLoading: false,
        planogramPageNum: 0,
        subCategoryPageNum: 0,
        isLoadMore: false,
        isBottomOfPlanoGrams: false,
        isBottomOfSubCategory: false,
        productDetails: [],
        planoGramUpdateIndex: -1,
        productStockUpdateIndex: -1,
        isSelectSupplier: false,
        productSupplierList: [],
        searchList: [],
        search: '',
        isSearching: false,
        imageIndex: 0,
      isBottomOfProducts: false,
        searchController: TextEditingController(),
        noteController: TextEditingController(),
        subCategoryRefreshController: RefreshController(),
        planogramRefreshController: RefreshController(),
    planoGramsByIdList: [],
    planogramProductList: [],
    categoryPlanogramList: [],
      subCategoryPlanogramList:[],
      subCatPlanoGramsList:[],
      subPlanogramPageNum:0,
      subPlanoGramsList:[],
    subProductPageNum: 0,
      isPlanogramProductShimmering:false,
    isGridView: true,
   isGuestUser : false,
    isBottomProducts : false,
    cartCount: 0,
    duringCelebration: false

      );
}
