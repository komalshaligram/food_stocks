part of 'product_category_bloc.dart';

@freezed
class ProductCategoryEvent with _$ProductCategoryEvent {
  const factory ProductCategoryEvent.getProductCategoriesListEvent(
      {required BuildContext context}) = _GetProductCategoriesListEvent;

  const factory ProductCategoryEvent.navigateToStoreCategoryEvent(
      {required BuildContext context}) = _NavigateToStoreCategoryEvent;

  const factory ProductCategoryEvent.setSearchNavEvent(
      {required String reqSearch,
      required bool isFromStoreCategory}) = _SetSearchNavEvent;

  const factory ProductCategoryEvent.updateGlobalSearchEvent(
      {required String search,
      required List<SearchModel> searchList}) = _UpdateGlobalSearchEvent;
}
