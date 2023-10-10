part of 'store_category_bloc.dart';

@freezed
class StoreCategoryState with _$StoreCategoryState {
  const factory StoreCategoryState(
      {required bool isCategoryExpand,
      required bool isShowCategory}) = _StoreCategoryState;

  factory StoreCategoryState.initial() =>
      const StoreCategoryState(isCategoryExpand: false, isShowCategory: false);
}
