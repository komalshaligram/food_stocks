part of 'store_category_bloc.dart';

@freezed
class StoreCategoryState with _$StoreCategoryState {
  const factory StoreCategoryState({
    required bool isCategoryExpand,
    required bool isCategory,
    required List<Datum> planoGramsList,
    required List<List<ProductStockModel>> productStockList,
    required bool isShimmering,
    required bool isLoading,
    required bool isProductLoading,
    required int pageNum,
    required bool isLoadMore,
    required bool isBottomOfPlanoGrams,
    required ProductDetailsResModel productDetails,
    required int planoGramUpdateIndex,
    required int productStockUpdateIndex,
  }) = _StoreCategoryState;

  factory StoreCategoryState.initial() => const StoreCategoryState(
    isCategoryExpand: false,
        isCategory: true,
        planoGramsList: [],
        productStockList: [],
        isShimmering: false,
        isLoading: false,
        isProductLoading: false,
        pageNum: 0,
        isLoadMore: false,
        isBottomOfPlanoGrams: false,
        productDetails: ProductDetailsResModel(),
        planoGramUpdateIndex: -1,
        productStockUpdateIndex: -1,
      );
}
