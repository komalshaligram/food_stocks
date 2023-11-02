part of 'store_category_bloc.dart';

@freezed
class StoreCategoryState with _$StoreCategoryState {
  const factory StoreCategoryState({
    required bool isCategoryExpand,
    required bool isCategory,
    required List<Datum> planogramsList,
    required List<List<ProductStockModel>> productStockList,
    required bool isShimmering,
    required bool isLoading,
    required bool isProductLoading,
    required int pageNum,
    required bool isLoadMore,
    required bool isBottomOfPlanograms,
  }) = _StoreCategoryState;

  factory StoreCategoryState.initial() => const StoreCategoryState(
    isCategoryExpand: false,
        isCategory: true,
        planogramsList: [],
        productStockList: [],
        isShimmering: false,
        isLoading: false,
        isProductLoading: false,
        pageNum: 0,
        isLoadMore: false,
        isBottomOfPlanograms: false,
      );
}
