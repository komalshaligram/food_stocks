part of 'store_category_bloc.dart';

@freezed
class StoreCategoryState with _$StoreCategoryState {
  const factory StoreCategoryState({
    required bool isCategoryExpand,
    required bool isCategory,
  }) = _StoreCategoryState;

  factory StoreCategoryState.initial() => const StoreCategoryState(
        isCategoryExpand: false,
        isCategory: true,
      );
}
