part of 'product_category_bloc.dart';

@freezed
class ProductCategoryEvent with _$ProductCategoryEvent {
  const factory ProductCategoryEvent.getProductCategoriesListEvent(
      {required BuildContext context}) = _GetProductCategoriesListEvent;

  const factory ProductCategoryEvent.navigateToStoreCategoryEvent(
      {required BuildContext context}) = _NavigateToStoreCategoryEvent;
}
