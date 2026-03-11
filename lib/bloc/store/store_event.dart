part of 'store_bloc.dart';

@freezed
class StoreEvent with _$StoreEvent {
  const factory StoreEvent.getPreferencesDataEvent() = _getPreferencesDataEvent;
  const factory StoreEvent.changeCategoryExpansion({
    bool? isOpened,
  }) = _changeCategoryExpansion;

  const factory StoreEvent.getProductCategoriesListEvent({
    required BuildContext context,
  }) = _getProductCategoriesListEvent;

  const factory StoreEvent.getProductSalesListEvent({
    required BuildContext context,
  }) = _getProductSalesListEvent;

  const factory StoreEvent.getRecommendationProductsListEvent({
    required BuildContext context,
  }) = _getRecommendationProductsListEvent;

  const factory StoreEvent.getPreviousOrderProductsListEvent({
    required BuildContext context,
  }) = _getPreviousOrderProductsListEvent;

  const factory StoreEvent.changeSearchListEvent({
    required List<SearchModel> newSearchList,
  }) = _changeSearchListEvent;

  const factory StoreEvent.getSuppliersListEvent({
    required BuildContext context,
  }) = _getSuppliersListEvent;

  const factory StoreEvent.getCompaniesListEvent({
    required BuildContext context,
  }) = _getCompaniesListEvent;

  const factory StoreEvent.getProductDetailsEvent({
    required BuildContext context,
    required String productId,
    required int productListIndex,
    bool? isBarcode,
  }) = _getProductDetailsEvent;

  const factory StoreEvent.increaseQuantityOfProduct({
    required BuildContext context,
  }) = _increaseQuantityOfProduct;

  const factory StoreEvent.decreaseQuantityOfProduct({
    required BuildContext context,
  }) = _decreaseQuantityOfProduct;

  const factory StoreEvent.updateQuantityOfProduct({
    required BuildContext context,
    required String quantity,
  }) = _updateQuantityOfProduct;

  const factory StoreEvent.changeNoteOfProduct({
    required String newNote,
  }) = _changeNoteOfProduct;

  const factory StoreEvent.changeSupplierSelectionExpansionEvent({
    bool? isSelectSupplier,
  }) = _changeSupplierSelectionExpansionEvent;

  const factory StoreEvent.supplierSelectionEvent({
    required int supplierIndex,
    required BuildContext context,
    required int supplierSaleIndex,
  }) = _supplierSelectionEvent;

  const factory StoreEvent.addToCartProductEvent({
    required BuildContext context,
    required String productId,
  }) = _addToCartProductEvent;

  const factory StoreEvent.setCartCountEvent() = _setCartCountEvent;

  const factory StoreEvent.globalSearchEvent({
    required BuildContext context,
  }) = _globalSearchEvent;

  const factory StoreEvent.resetGlobalSearchEvent() = _resetGlobalSearchEvent;

  const factory StoreEvent.updateImageIndexEvent({
    required int index,
  }) = _updateImageIndexEvent;

  const factory StoreEvent.updateGlobalSearchEvent({
    required String search,
    required List<SearchModel> searchList,
  }) = _updateGlobalSearchEvent;

  const factory StoreEvent.toggleNoteEvent({
    required bool isBarcode,
  }) = _toggleNoteEvent;

  const factory StoreEvent.relatedProductsEvent({
    required BuildContext context,
    required String productId,
  }) = _relatedProductsEvent;

  const factory StoreEvent.removeRelatedProductEvent() = _removeRelatedProductEvent;

  const factory StoreEvent.getPermissionList({
    required BuildContext context,
  }) = _getPermissionList;

  const factory StoreEvent.userApproveEvent({
    required BuildContext context,
  }) = _userApproveEvent;

  const factory StoreEvent.generalSettings({
    required BuildContext context,
    required BuildContext dialogContext,
    required bool isRetryLoading,
  }) = _generalSettings;

  const factory StoreEvent.updateMaintenanceEvent({
    required BuildContext context,
  }) = _updateMaintenanceEvent;

  const factory StoreEvent.updateListQuantityOfProduct({
    required BuildContext context,
    required String quantity,
    required int productListIndex,
    required int productStockUpdateIndex,
    required String productSupplierIds,
  }) = _updateListQuantityOfProductEvent;

  const factory StoreEvent.increaseListQuantityOfProduct({
    required BuildContext context,
    required int productListIndex,
    required int productStockUpdateIndex,
    required String productSupplierIds,
  }) = _increaseListQuantityOfProductEvent;

  const factory StoreEvent.decreaseListQuantityOfProduct({
    required BuildContext context,
    required int productListIndex,
    required int productStockUpdateIndex,
    required String productSupplierIds,
  }) = _decreaseListQuantityOfProductEvent;

  const factory StoreEvent.addToCartListProductEvent({
    required BuildContext context,
    required String productId,
    required int productListIndex,
    required int productStockUpdateIndex,
    required String productSupplierIds,
  }) = _addToCartListProductEvent;

  const factory StoreEvent.getCartCountEvent({
    required BuildContext context,
  }) = _getCartCountEvent;
}
