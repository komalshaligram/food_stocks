part of 'product_category_bloc.dart';

@freezed
class ProductCategoryState with _$ProductCategoryState {
  const factory ProductCategoryState({
    required List<Category> productCategoryList,
    required bool isShimmering,
    required bool isLoadMore,
    required int pageNum,
    required bool isBottomOfCategories,
  }) = _ProductCategoryState;

  factory ProductCategoryState.initial() => ProductCategoryState(
        productCategoryList: [],
        isShimmering: false,
        isLoadMore: false,
        pageNum: 0,
        isBottomOfCategories: false,
      );
}
