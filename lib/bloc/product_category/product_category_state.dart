part of 'product_category_bloc.dart';

@freezed
class ProductCategoryState with _$ProductCategoryState {
  const factory ProductCategoryState({
    required List<Category> productCategoryList,
    required bool isShimmering,
    required bool isLoadMore,
    required int pageNum,
    required bool isBottomOfCategories,
    required bool isFromStoreCategory,
    required List<SearchModel> searchList,
    required String search,
    required String reqSearch,
    required RefreshController refreshController,
  }) = _ProductCategoryState;

  factory ProductCategoryState.initial() => ProductCategoryState(
    productCategoryList: [],
        isShimmering: false,
        isLoadMore: false,
        pageNum: 0,
        isBottomOfCategories: false,
        isFromStoreCategory: false,
        searchList: [],
        search: '',
        reqSearch: '',
        refreshController: RefreshController(),
      );
}
