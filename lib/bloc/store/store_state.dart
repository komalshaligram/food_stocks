part of 'store_bloc.dart';

@freezed
class StoreState with _$StoreState {
  const factory StoreState({
    required bool isCategoryExpand,
    required bool isMirror,
    required ProductCategoriesResModel productCategoryList,
  }) = _StoreState;

  factory StoreState.initial() => const StoreState(
        isCategoryExpand: false,
        isMirror: false,
        productCategoryList: ProductCategoriesResModel(),
      );
}
