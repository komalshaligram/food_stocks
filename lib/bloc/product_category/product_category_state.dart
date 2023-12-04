part of 'product_category_bloc.dart';

@freezed
class ProductCategoryState with _$ProductCategoryState {
  const factory ProductCategoryState({
    required List<Category> productCategoryList,
    required String search,
    required bool isShimmering,
    required bool isLoadMore,
    required int pageNum,
    required bool isBottomOfCategories,
    required bool isFromStoreCategory,
  }) = _ProductCategoryState;

  factory ProductCategoryState.initial() => ProductCategoryState(
    productCategoryList: [],
        search: '',
        isShimmering: false,
        isLoadMore: false,
        pageNum: 0,
        isBottomOfCategories: false,
        isFromStoreCategory: false,
      );
}
