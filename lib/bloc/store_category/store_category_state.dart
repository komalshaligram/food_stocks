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
    required bool isShimmering,
    required bool isLoading,
    required bool isProductLoading,
    required int planogramPageNum,
    required int subCategoryPageNum,
    required bool isLoadMore,
    required bool isBottomOfPlanoGrams,
    required bool isBottomOfSubCategory,
    required ProductDetailsResModel productDetails,
    required int planoGramUpdateIndex,
    required int productStockUpdateIndex,
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
        isShimmering: false,
        isLoading: false,
        isProductLoading: false,
        planogramPageNum: 0,
        subCategoryPageNum: 0,
        isLoadMore: false,
        isBottomOfPlanoGrams: false,
        isBottomOfSubCategory: false,
        productDetails: ProductDetailsResModel(),
        planoGramUpdateIndex: -1,
        productStockUpdateIndex: -1,
      );
}
