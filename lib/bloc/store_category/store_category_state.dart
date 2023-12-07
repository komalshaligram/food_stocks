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
    required List<Datum> planoGramsList,
    required List<List<ProductStockModel>> productStockList,
    required bool isPlanogramShimmering,
    required bool isSubCategoryShimmering,
    required bool isLoading,
    required bool isProductLoading,
    required int planogramPageNum,
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
    required String previousSearch,
    required int imageIndex,
  }) = _StoreCategoryState;

  factory StoreCategoryState.initial() => const StoreCategoryState(
    isCategoryExpand: false,
        isSubCategory: true,
        categoryId: '',
        subCategoryId: '',
        categoryName: '',
        subCategoryName: '',
        subCategoryList: [],
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
        previousSearch: '',
        imageIndex: 0,
      );
}
