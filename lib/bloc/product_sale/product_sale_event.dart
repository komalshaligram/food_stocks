part of 'product_sale_bloc.dart';

@freezed
class ProductSaleEvent with _$ProductSaleEvent {
  const factory ProductSaleEvent.getPreferencesDataEvent() = _getPreferencesDataEvent;

  const factory ProductSaleEvent.getProductSalesListEvent({required BuildContext context}) = _getProductSalesListEvent;

  const factory ProductSaleEvent.getProductDetailsEvent(
      {required BuildContext context, required bool isBarcode, required int productListIndex, required String productId}) = _getProductDetailsEvent;

  const factory ProductSaleEvent.increaseQuantityOfProduct({required BuildContext context}) = _increaseQuantityOfProduct;

  const factory ProductSaleEvent.decreaseQuantityOfProduct({required BuildContext context}) = _decreaseQuantityOfProduct;

  const factory ProductSaleEvent.updateQuantityOfProduct({required BuildContext context, required String quantity}) = _updateQuantityOfProduct;

  const factory ProductSaleEvent.changeNoteOfProduct({required String newNote}) = _changeNoteOfProduct;

  const factory ProductSaleEvent.changeSupplierSelectionExpansionEvent({bool? isSelectSupplier}) = _changeSupplierSelectionExpansionEvent;

  const factory ProductSaleEvent.supplierSelectionEvent({required int supplierIndex, required BuildContext context, required int supplierSaleIndex}) =
      _supplierSelectionEvent;

  const factory ProductSaleEvent.addToCartProductEvent({required BuildContext context, required String productId}) = _addToCartProductEvent;

  const factory ProductSaleEvent.setCartCountEvent() = _setCartCountEvent;

  const factory ProductSaleEvent.updateImageIndexEvent({required int index}) = _updateImageIndexEvent;

  const factory ProductSaleEvent.setSearchEvent({required String search}) = _setSearchEvent;

  const factory ProductSaleEvent.toggleNoteEvent() = _toggleNoteEvent;

  const factory ProductSaleEvent.refreshListEvent({required BuildContext context}) = _RefreshListEvent;

  const factory ProductSaleEvent.relatedProductsEvent({required BuildContext context, required String productId}) = _relatedProductsEvent;

  const factory ProductSaleEvent.removeRelatedProductEvent() = _removeRelatedProductEvent;

  const factory ProductSaleEvent.getGridListView() = _getGridListView;

  const factory ProductSaleEvent.userApproveEvent({required BuildContext context}) = _userApproveEvent;

  const factory ProductSaleEvent.updateListQuantityOfProduct(
      {required BuildContext context,
      required String quantity,
      required int productListIndex,
      required int productStockUpdateIndex,
      required String productSupplierIds}) = _updateListQuantityOfProductEvent;

  const factory ProductSaleEvent.increaseListQuantityOfProduct(
      {required BuildContext context,
      required int productListIndex,
      required int productStockUpdateIndex,
      required String productSupplierIds}) = _increaseListQuantityOfProductEvent;

  const factory ProductSaleEvent.decreaseListQuantityOfProduct(
      {required BuildContext context,
      required int productListIndex,
      required int productStockUpdateIndex,
      required String productSupplierIds}) = _decreaseListQuantityOfProductEvent;

  const factory ProductSaleEvent.addToCartListProductEvent(
      {required BuildContext context,
      required String productId,
      required int productListIndex,
      required int productStockUpdateIndex,
      required String productSupplierIds}) = _addToCartListProductEvent;

  const factory ProductSaleEvent.getCartCountEvent({required BuildContext context}) = _getCartCountEvent;

  const factory ProductSaleEvent.applyCartQuantitiesEvent({required Map<String, int> cartQuantities}) = _applyCartQuantitiesEvent;
}
