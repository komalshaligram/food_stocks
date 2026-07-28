part of 'supplier_products_bloc.dart';

@freezed
class SupplierProductsEvent with _$SupplierProductsEvent {
  const factory SupplierProductsEvent.getPreferencesDataEvent() = _getPreferencesDataEvent;

  const factory SupplierProductsEvent.getSupplierProductsIdEvent({required String supplierId, required String search}) = _getSupplierProductsIdEvent;

  const factory SupplierProductsEvent.getSupplierProductsListEvent({required BuildContext context, required String searchType}) = _getSupplierProductsListEvent;

  const factory SupplierProductsEvent.getProductDetailsEvent({
    required BuildContext context,
    required String productId,
    required bool isBarcode,
    required int productListIndex,
  }) = _getProductDetailsEvent;

  const factory SupplierProductsEvent.increaseQuantityOfProduct({required BuildContext context}) = _increaseQuantityOfProduct;

  const factory SupplierProductsEvent.decreaseQuantityOfProduct({required BuildContext context}) = _decreaseQuantityOfProduct;

  const factory SupplierProductsEvent.updateQuantityOfProduct({required BuildContext context, required String quantity}) = _updateQuantityOfProduct;

  const factory SupplierProductsEvent.changeNoteOfProduct({required String newNote}) = _changeNoteOfProduct;

  const factory SupplierProductsEvent.changeSupplierSelectionExpansionEvent({bool? isSelectSupplier}) = _changeSupplierSelectionExpansionEvent;

  const factory SupplierProductsEvent.supplierSelectionEvent({required int supplierIndex, required BuildContext context, required int supplierSaleIndex}) = _supplierSelectionEvent;

  const factory SupplierProductsEvent.addToCartProductEvent({required BuildContext context, required String productId}) = _addToCartProductEvent;

  const factory SupplierProductsEvent.setCartCountEvent() = _setCartCountEvent;

  const factory SupplierProductsEvent.updateImageIndexEvent({required int index}) = _updateImageIndexEvent;

  const factory SupplierProductsEvent.toggleNoteEvent() = _toggleNoteEvent;

  const factory SupplierProductsEvent.refreshListEvent({required BuildContext context}) = _refreshListEvent;

  const factory SupplierProductsEvent.getAllProducts({required BuildContext context, required String search}) = _getAllProductsEvent;

  const factory SupplierProductsEvent.getGridListView() = _getGridListView;

  const factory SupplierProductsEvent.changeCategoryExpansion({bool? isOpened}) = _changeCategoryExpansion;

  const factory SupplierProductsEvent.globalSearchEvent({required BuildContext context}) = _globalSearchEvent;

  const factory SupplierProductsEvent.updateGlobalSearchEvent({required String search, required List<SearchModel> searchList}) = _updateGlobalSearchEvent;

  const factory SupplierProductsEvent.relatedProductsEvent({required BuildContext context, required String productId}) = _relatedProductsEvent;

  const factory SupplierProductsEvent.removeRelatedProductEvent() = _removeRelatedProductEvent;

  const factory SupplierProductsEvent.getPermissionList({required BuildContext context}) = _getPermissionList;

  const factory SupplierProductsEvent.userApproveEvent({required BuildContext context}) = _userApproveEvent;

  const factory SupplierProductsEvent.updateListQuantityOfProduct({
    required BuildContext context,
    required String quantity,
    required int productListIndex,
    required int productStockUpdateIndex,
    required String productSupplierIds,
  }) = _updateListQuantityOfProductEvent;

  const factory SupplierProductsEvent.increaseListQuantityOfProduct({
    required BuildContext context,
    required int productListIndex,
    required int productStockUpdateIndex,
    required String productSupplierIds,
  }) = _increaseListQuantityOfProductEvent;

  const factory SupplierProductsEvent.decreaseListQuantityOfProduct({
    required BuildContext context,
    required int productListIndex,
    required int productStockUpdateIndex,
    required String productSupplierIds,
  }) = _decreaseListQuantityOfProductEvent;

  const factory SupplierProductsEvent.addToCartListProductEvent({
    required BuildContext context,
    required String productId,
    required int productListIndex,
    required int productStockUpdateIndex,
    required String productSupplierIds,
  }) = _addToCartListProductEvent;

  const factory SupplierProductsEvent.getCartCountEvent({required BuildContext context}) = _getCartCountEvent;

  const factory SupplierProductsEvent.applyCartQuantitiesEvent({
    required Map<String, int> cartQuantities,
  }) = _applyCartQuantitiesEvent;
}
