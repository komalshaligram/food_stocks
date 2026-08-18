part of 'supplier_brand_products_bloc.dart';

@freezed
class SupplierBrandProductsEvent with _$SupplierBrandProductsEvent {
  const factory SupplierBrandProductsEvent.getPreferencesDataEvent() = _getPreferencesDataEvent;

  const factory SupplierBrandProductsEvent.getBrandProductsListEvent(
      {required BuildContext context, required String supplierId, required String brandId}) = _getBrandProductsListEvent;

  const factory SupplierBrandProductsEvent.getCategoryProductsListEvent(
      {required BuildContext context, required String supplierId, required String categoryId}) = _getCategoryProductsListEvent;

  const factory SupplierBrandProductsEvent.selectSubCategoryEvent(
      {required BuildContext context,
      required String supplierId,
      required String categoryId,
      required String subCategoryId}) = _selectSubCategoryEvent;

  const factory SupplierBrandProductsEvent.getProductDetailsEvent(
      {required BuildContext context, required String productId, required bool isBarcode, required int productListIndex}) = _getProductDetailsEvent;

  const factory SupplierBrandProductsEvent.increaseQuantityOfProduct({required BuildContext context}) = _increaseQuantityOfProduct;

  const factory SupplierBrandProductsEvent.decreaseQuantityOfProduct({required BuildContext context}) = _decreaseQuantityOfProduct;

  const factory SupplierBrandProductsEvent.updateQuantityOfProduct({required BuildContext context, required String quantity}) =
      _updateQuantityOfProduct;

  const factory SupplierBrandProductsEvent.changeNoteOfProduct({required String newNote}) = _changeNoteOfProduct;

  const factory SupplierBrandProductsEvent.changeSupplierSelectionExpansionEvent({bool? isSelectSupplier}) = _changeSupplierSelectionExpansionEvent;

  const factory SupplierBrandProductsEvent.supplierSelectionEvent(
      {required int supplierIndex, required BuildContext context, required int supplierSaleIndex}) = _supplierSelectionEvent;

  const factory SupplierBrandProductsEvent.addToCartProductEvent({required BuildContext context, required String productId}) = _addToCartProductEvent;

  const factory SupplierBrandProductsEvent.setCartCountEvent() = _setCartCountEvent;

  const factory SupplierBrandProductsEvent.updateImageIndexEvent({required int index}) = _updateImageIndexEvent;

  const factory SupplierBrandProductsEvent.toggleNoteEvent() = _toggleNoteEvent;

  const factory SupplierBrandProductsEvent.refreshListEvent(
      {required BuildContext context, required String supplierId, String? brandId, String? categoryId}) = _refreshListEvent;

  const factory SupplierBrandProductsEvent.getCartCountEvent() = _getCartCountEvent;

  const factory SupplierBrandProductsEvent.getGridListView() = _getGridListView;

  const factory SupplierBrandProductsEvent.changeCategoryExpansion({bool? isOpened}) = _changeCategoryExpansion;

  const factory SupplierBrandProductsEvent.globalSearchEvent({required BuildContext context}) = _globalSearchEvent;

  const factory SupplierBrandProductsEvent.updateGlobalSearchEvent({required String search, required List<SearchModel> searchList}) =
      _updateGlobalSearchEvent;

  const factory SupplierBrandProductsEvent.getProductCategoriesListEvent({required BuildContext context}) = _getProductCategoriesListEvent;

  const factory SupplierBrandProductsEvent.relatedProductsEvent({required BuildContext context, required String productId}) = _relatedProductsEvent;

  const factory SupplierBrandProductsEvent.removeRelatedProductEvent() = _removeRelatedProductEvent;

  const factory SupplierBrandProductsEvent.getPermissionList({required BuildContext context}) = _getPermissionList;

  const factory SupplierBrandProductsEvent.userApproveEvent({required BuildContext context}) = _userApproveEvent;

  const factory SupplierBrandProductsEvent.updateListQuantityOfProduct(
      {required BuildContext context,
      required String quantity,
      required int productListIndex,
      required int productStockUpdateIndex,
      required String productSupplierIds}) = _updateListQuantityOfProductEvent;

  const factory SupplierBrandProductsEvent.increaseListQuantityOfProduct(
      {required BuildContext context,
      required int productListIndex,
      required int productStockUpdateIndex,
      required String productSupplierIds}) = _increaseListQuantityOfProductEvent;

  const factory SupplierBrandProductsEvent.decreaseListQuantityOfProduct(
      {required BuildContext context,
      required int productListIndex,
      required int productStockUpdateIndex,
      required String productSupplierIds}) = _decreaseListQuantityOfProductEvent;

  const factory SupplierBrandProductsEvent.addToCartListProductEvent(
      {required BuildContext context,
      required String productId,
      required int productListIndex,
      required int productStockUpdateIndex,
      required String productSupplierIds}) = _addToCartListProductEvent;

  const factory SupplierBrandProductsEvent.getCartCountNoEvent({required BuildContext context}) = _getCartCountNoEvent;

  const factory SupplierBrandProductsEvent.applyCartQuantitiesEvent({required Map<String, int> cartQuantities}) = _applyCartQuantitiesEvent;
}
