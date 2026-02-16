part of 'company_products_bloc.dart';

@freezed
class CompanyProductsEvent with _$CompanyProductsEvent {
  const factory CompanyProductsEvent.getCompanyProductsIdEvent({
    required String companyId,
  }) = _getCompanyProductsIdEvent;

  const factory CompanyProductsEvent.getCompanyProductsListEvent({
    required BuildContext context,
  }) = _getCompanyProductsListEvent;

  const factory CompanyProductsEvent.getProductDetailsEvent({
    required BuildContext context,
    required String productId,
    required bool isBarcode,
    required int productListIndex,
  }) = _getProductDetailsEvent;

  const factory CompanyProductsEvent.increaseQuantityOfProduct({
    required BuildContext context,
  }) = _increaseQuantityOfProduct;

  const factory CompanyProductsEvent.decreaseQuantityOfProduct({
    required BuildContext context,
  }) = _decreaseQuantityOfProduct;

  const factory CompanyProductsEvent.updateQuantityOfProduct({
    required BuildContext context,
    required String quantity,
  }) = _updateQuantityOfProduct;

  const factory CompanyProductsEvent.changeNoteOfProduct({
    required String newNote,
  }) = _changeNoteOfProduct;

  const factory CompanyProductsEvent.changeSupplierSelectionExpansionEvent({
    bool? isSelectSupplier,
  }) = _changeSupplierSelectionExpansionEvent;

  const factory CompanyProductsEvent.supplierSelectionEvent({
    required int supplierIndex,
    required BuildContext context,
    required int supplierSaleIndex,
  }) = _supplierSelectionEvent;

  const factory CompanyProductsEvent.addToCartProductEvent({
    required BuildContext context,
    required String productId,
  }) = _addToCartProductEvent;

  const factory CompanyProductsEvent.setCartCountEvent() = _setCartCountEvent;

  const factory CompanyProductsEvent.updateImageIndexEvent({
    required int index,
  }) = _updateImageIndexEvent;

  const factory CompanyProductsEvent.toggleNoteEvent() = _toggleNoteEvent;

  const factory CompanyProductsEvent.refreshListEvent({
    required BuildContext context,
  }) = _refreshListEvent;

  const factory CompanyProductsEvent.getCartCountEvent() = _getCartCountEvent;

  const factory CompanyProductsEvent.getGridListView() = _getGridListView;

  const factory CompanyProductsEvent.changeCategoryExpansion({
    bool? isOpened,
  }) = _changeCategoryExpansion;

  const factory CompanyProductsEvent.globalSearchEvent({
    required BuildContext context,
  }) = _globalSearchEvent;

  const factory CompanyProductsEvent.updateGlobalSearchEvent({
    required String search,
    required List<SearchModel> searchList,
  }) = _updateGlobalSearchEvent;

  const factory CompanyProductsEvent.getProductCategoriesListEvent({
    required BuildContext context,
  }) = _getProductCategoriesListEvent;

  const factory CompanyProductsEvent.relatedProductsEvent({
    required BuildContext context,
    required String productId,
  }) = _relatedProductsEvent;

  const factory CompanyProductsEvent.removeRelatedProductEvent() = _removeRelatedProductEvent;

  const factory CompanyProductsEvent.getPermissionList({
    required BuildContext context,
  }) = _getPermissionList;

  const factory CompanyProductsEvent.userApproveEvent({
    required BuildContext context,
  }) = _userApproveEvent;

  const factory CompanyProductsEvent.updateListQuantityOfProduct({
    required BuildContext context,
    required String quantity,
    required int productListIndex,
    required int productStockUpdateIndex,
    required String productSupplierIds,
  }) = _updateListQuantityOfProductEvent;

  const factory CompanyProductsEvent.increaseListQuantityOfProduct({
    required BuildContext context,
    required int productListIndex,
    required int productStockUpdateIndex,
    required String productSupplierIds,
  }) = _increaseListQuantityOfProductEvent;

  const factory CompanyProductsEvent.decreaseListQuantityOfProduct({
    required BuildContext context,
    required int productListIndex,
    required int productStockUpdateIndex,
    required String productSupplierIds,
  }) = _decreaseListQuantityOfProductEvent;

  const factory CompanyProductsEvent.addToCartListProductEvent({
    required BuildContext context,
    required String productId,
    required int productListIndex,
    required int productStockUpdateIndex,
    required String productSupplierIds,
  }) = _addToCartListProductEvent;

  const factory CompanyProductsEvent.getCartCountNoEvent({
    required BuildContext context,
  }) = _getCartCountNoEvent;
}
