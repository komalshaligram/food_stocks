part of 'store_category_bloc.dart';

@freezed
class StoreCategoryEvent with _$StoreCategoryEvent {
  const factory StoreCategoryEvent.getPreferencesDataEvent() = _getPreferencesDataEvent;

  const factory StoreCategoryEvent.changeCategoryExpansionEvent({bool? isOpened}) = _changeCategoryExpansionEvent;

  const factory StoreCategoryEvent.getProductCategoriesListEvent({required BuildContext context}) = _getProductCategoriesListEvent;

  const factory StoreCategoryEvent.changeCategoryDetailsEvent(
      {required String categoryId,
      required String categoryName,
      required String isSubCategory,
      required BuildContext context}) = _changeCategoryDetailsEvent;

  const factory StoreCategoryEvent.changeSubCategoryDetailsEvent(
      {required String subCategoryId, required String subCategoryName, required BuildContext context}) = _changeSubCategoryDetailsEvent;

  const factory StoreCategoryEvent.getSubCategoryListEvent({required BuildContext context}) = _getSubCategoryListEvent;

  const factory StoreCategoryEvent.changeSubCategoryOrPlanogramEvent({required bool isSubCategory, required BuildContext context}) =
      _changeSubCategoryOrPlanogramEvent;

  const factory StoreCategoryEvent.getPlanoGramProductsEvent({required BuildContext context}) = _getPlanoGramProductsEvent;

  const factory StoreCategoryEvent.getProductDetailsEvent(
      {required BuildContext context, required String productId, required int planoGramIndex, required bool isBarcode}) = _getProductDetailsEvent;

  const factory StoreCategoryEvent.increaseQuantityOfProduct({required BuildContext context}) = _increaseQuantityOfProduct;

  const factory StoreCategoryEvent.decreaseQuantityOfProduct({required BuildContext context}) = _decreaseQuantityOfProduct;

  const factory StoreCategoryEvent.updateQuantityOfProduct({required BuildContext context, required String quantity}) = _updateQuantityOfProduct;

  const factory StoreCategoryEvent.changeNoteOfProduct({required String newNote}) = _changeNoteOfProduct;

  const factory StoreCategoryEvent.changeSupplierSelectionExpansionEvent({bool? isSelectSupplier}) = _changeSupplierSelectionExpansionEvent;

  const factory StoreCategoryEvent.supplierSelectionEvent(
      {required int supplierIndex, required BuildContext context, required int supplierSaleIndex}) = _supplierSelectionEvent;

  const factory StoreCategoryEvent.addToCartProductEvent({required BuildContext context, required String productId}) = _addToCartProductEvent;

  const factory StoreCategoryEvent.setCartCountEvent() = _setCartCountEvent;

  const factory StoreCategoryEvent.globalSearchEvent({required BuildContext context}) = _globalSearchEvent;

  const factory StoreCategoryEvent.updateImageIndexEvent({required int index}) = _updateImageIndexEvent;

  const factory StoreCategoryEvent.updateGlobalSearchEvent(
      {required String search, required BuildContext context, required List<SearchModel> searchList}) = _updateGlobalSearchEvent;

  const factory StoreCategoryEvent.toggleNoteEvent({required bool isBarcode}) = _toggleNoteEvent;

  const factory StoreCategoryEvent.subCategoryRefreshListEvent({required BuildContext context}) = _subCategoryRefreshListEvent;

  const factory StoreCategoryEvent.planogramRefreshListEvent({required BuildContext context}) = _planogramRefreshListEvent;

  const factory StoreCategoryEvent.isCategoryEvent({required bool isSubCategory}) = _isCategoryEvent;

  const factory StoreCategoryEvent.getPlanogramByIdEvent({required BuildContext context}) = _getPlanogramByIdEvent;

  const factory StoreCategoryEvent.getPlanogramAllProductEvent({required BuildContext context}) = _getPlanogramAllProductEvent;

  const factory StoreCategoryEvent.getSubCategoryProductEvent({required BuildContext context}) = _getSubCategoryProductEvent;

  const factory StoreCategoryEvent.changeGridToListViewEvent({required bool isGridView}) = _changeGridToListViewEvent;

  const factory StoreCategoryEvent.allProductsRefreshListEvent({required BuildContext context}) = _allProductsRefreshListEvent;

  const factory StoreCategoryEvent.relatedProductsEvent({required BuildContext context, required String productId}) = _relatedProductsEvent;
  const factory StoreCategoryEvent.removeRelatedProductEvent() = _removeRelatedProductEvent;

  const factory StoreCategoryEvent.getPermissionList({required BuildContext context}) = _getPermissionList;

  const factory StoreCategoryEvent.userApproveEvent({required BuildContext context}) = _userApproveEvent;

  const factory StoreCategoryEvent.updateListQuantityOfProduct(
      {required BuildContext context,
      required String quantity,
      required int productListIndex,
      required int productStockUpdateIndex,
      required String productSupplierIds}) = _updateListQuantityOfProductEvent;

  const factory StoreCategoryEvent.increaseListQuantityOfProduct(
      {required BuildContext context,
      required int productListIndex,
      required int productStockUpdateIndex,
      required String productSupplierIds}) = _increaseListQuantityOfProductEvent;

  const factory StoreCategoryEvent.decreaseListQuantityOfProduct(
      {required BuildContext context,
      required int productListIndex,
      required int productStockUpdateIndex,
      required String productSupplierIds}) = _decreaseListQuantityOfProductEvent;

  const factory StoreCategoryEvent.addToCartListProductEvent(
      {required BuildContext context,
      required String productId,
      required int productListIndex,
      required int productStockUpdateIndex,
      required String productSupplierIds}) = _addToCartListProductEvent;

  const factory StoreCategoryEvent.getCartCountEvent({BuildContext? context}) = _getCartCountEvent;

  const factory StoreCategoryEvent.applyCartQuantitiesEvent({required Map<String, int> cartQuantities}) = _applyCartQuantitiesEvent;
}
