part of 'pesach_products_bloc.dart';

@freezed
class PesachProductsEvent with _$PesachProductsEvent {
  const factory PesachProductsEvent.getPreferencesDataEvent() = _getPreferencesDataEvent;

  const factory PesachProductsEvent.getSupplierProductsIdEvent({required String supplierId, required String search}) = _getSupplierProductsIdEvent;

  const factory PesachProductsEvent.getSupplierProductsListEvent({required BuildContext context, required String searchType}) = _getSupplierProductsListEvent;

  const factory PesachProductsEvent.getProductDetailsEvent({
    required BuildContext context,
    required String productId,
    required bool isBarcode,
    required int productListIndex,
  }) = _getProductDetailsEvent;

  const factory PesachProductsEvent.increaseQuantityOfProduct({required BuildContext context}) = _increaseQuantityOfProduct;

  const factory PesachProductsEvent.decreaseQuantityOfProduct({required BuildContext context}) = _decreaseQuantityOfProduct;

  const factory PesachProductsEvent.updateQuantityOfProduct({required BuildContext context, required String quantity}) = _updateQuantityOfProduct;

  const factory PesachProductsEvent.changeNoteOfProduct({required String newNote}) = _changeNoteOfProduct;

  const factory PesachProductsEvent.changeSupplierSelectionExpansionEvent({bool? isSelectSupplier}) = _changeSupplierSelectionExpansionEvent;

  const factory PesachProductsEvent.supplierSelectionEvent({required int supplierIndex, required BuildContext context, required int supplierSaleIndex}) = _supplierSelectionEvent;

  const factory PesachProductsEvent.addToCartProductEvent({required BuildContext context, required String productId}) = _addToCartProductEvent;

  const factory PesachProductsEvent.setCartCountEvent() = _setCartCountEvent;

  const factory PesachProductsEvent.updateImageIndexEvent({required int index}) = _updateImageIndexEvent;

  const factory PesachProductsEvent.toggleNoteEvent() = _toggleNoteEvent;

  const factory PesachProductsEvent.refreshListEvent({required BuildContext context}) = _refreshListEvent;

  const factory PesachProductsEvent.getAllProducts({required BuildContext context, required String search}) = _getAllProductsEvent;

  const factory PesachProductsEvent.getGridListView() = _getGridListView;

  const factory PesachProductsEvent.changeCategoryExpansion({bool? isOpened}) = _changeCategoryExpansion;

  const factory PesachProductsEvent.globalSearchEvent({required BuildContext context}) = _globalSearchEvent;

  const factory PesachProductsEvent.updateGlobalSearchEvent({required String search, required List<SearchModel> searchList}) = _updateGlobalSearchEvent;

  const factory PesachProductsEvent.relatedProductsEvent({required BuildContext context, required String productId}) = _relatedProductsEvent;

  const factory PesachProductsEvent.removeRelatedProductEvent() = _removeRelatedProductEvent;

  const factory PesachProductsEvent.getCartCountEvent() = _getCartCountEvent;

  const factory PesachProductsEvent.getPermissionList({required BuildContext context}) = _getPermissionList;

  const factory PesachProductsEvent.userApproveEvent({required BuildContext context}) = _userApproveEvent;

  const factory PesachProductsEvent.updateListQuantityOfProduct({
    required BuildContext context,
    required String quantity,
    required int productListIndex,
    required int productStockUpdateIndex,
    required String productSupplierIds,
  }) = _updateListQuantityOfProductEvent;

  const factory PesachProductsEvent.increaseListQuantityOfProduct({
    required BuildContext context,
    required int productListIndex,
    required int productStockUpdateIndex,
    required String productSupplierIds,
  }) = _increaseListQuantityOfProductEvent;

  const factory PesachProductsEvent.decreaseListQuantityOfProduct({
    required BuildContext context,
    required int productListIndex,
    required int productStockUpdateIndex,
    required String productSupplierIds,
  }) = _decreaseListQuantityOfProductEvent;

  const factory PesachProductsEvent.addToCartListProductEvent({
    required BuildContext context,
    required String productId,
    required int productListIndex,
    required int productStockUpdateIndex,
    required String productSupplierIds,
  }) = _addToCartListProductEvent;

  const factory PesachProductsEvent.getCartCountNoEvent({required BuildContext context}) = _getCartCountNoEvent;

  const factory PesachProductsEvent.applyCartQuantitiesEvent({
    required Map<String, int> cartQuantities,
  }) = _applyCartQuantitiesEvent;
}
