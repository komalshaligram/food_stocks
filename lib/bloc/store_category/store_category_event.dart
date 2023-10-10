part of 'store_category_bloc.dart';

@freezed
class StoreCategoryEvent with _$StoreCategoryEvent {
  const factory StoreCategoryEvent.changeCategoryExpansion({bool? isOpened}) =
      _ChangeCategoryExpansion;

  const factory StoreCategoryEvent.showCategoryOrSubCategory({bool? isOpened}) =
      _ShowCategoryOrSubCategory;
}
