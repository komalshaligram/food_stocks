part of 'product_category_bloc.dart';

@freezed
class ProductCategoryEvent with _$ProductCategoryEvent {
  const factory ProductCategoryEvent.getProductCategoriesListEvent({required BuildContext context}) = _getProductCategoriesListEvent;

  const factory ProductCategoryEvent.navigateToStoreCategoryEvent({required BuildContext context}) = _navigateToStoreCategoryEvent;

  const factory ProductCategoryEvent.setSearchNavEvent({required String reqSearch, required bool isFromStoreCategory}) = _setSearchNavEvent;

  const factory ProductCategoryEvent.updateGlobalSearchEvent({required String search, required List<SearchModel> searchList}) = _updateGlobalSearchEvent;

  const factory ProductCategoryEvent.refreshListEvent({required BuildContext context}) = _refreshListEvent;

  const factory ProductCategoryEvent.getCartCountEvent() = _getCartCountEvent;
}
