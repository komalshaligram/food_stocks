part of 'basket_bloc.dart';

@freezed
class BasketEvent with _$BasketEvent {
  const factory BasketEvent.getPreferencesDataEvent() = _getPreferencesDataEvent;
  const factory BasketEvent.productUpdateEvent({
    required int productWeight,
    required int listIndex,
    required BuildContext context,
    required String supplierId,
    required String productId,
    required String cartProductId,
    required double totalPayment,
    required String saleId,
  }) = _productUpdateEvent;

  const factory BasketEvent.removeCartProductEvent({
    required int listIndex,
    required BuildContext dialogContext,
    required BuildContext context,
    required String cartProductId,
    required double totalAmount,
    required bool isFromDelete,
  }) = _removeCartProductEvent;

  const factory BasketEvent.getAllCartEvent({
    required BuildContext context,
    required bool isFromUpdate,
  }) = _getAllCartEvent;

  const factory BasketEvent.clearCartEvent({
    required BuildContext context,
  }) = _clearCartEvent;

  const factory BasketEvent.payWithBankTransferEvent({
    required BuildContext context,
    required bool isFromRemovePopUp,
    required String id,
  }) = _payWithBankTransferEvent;

  const factory BasketEvent.setCartCountEvent({
    required bool isClearCart,
  }) = _setCartCountEvent;

  const factory BasketEvent.updateImageIndexEvent({
    required int index,
  }) = _updateImageIndexEvent;

  const factory BasketEvent.orderSendEvent({
    required BuildContext context,
    required bool failPayment,
    required bool isFromDialog,
    required String paymentMethod,
    required bool isFromRemovePopUp,
  }) = _orderSendEvent;
  const factory BasketEvent.increaseQuantityOfProduct({
    required BuildContext context,
  }) = _increaseQuantityOfProduct;

  const factory BasketEvent.decreaseQuantityOfProduct({
    required BuildContext context,
  }) = _decreaseQuantityOfProduct;

  const factory BasketEvent.updateQuantityOfProduct({
    required BuildContext context,
    required String quantity,
  }) = _updateQuantityOfProduct;

  const factory BasketEvent.getProductDetailsEvent({
    required BuildContext context,
    required bool isBarcode,
    required int productListIndex,
    required String productId,
  }) = _getProductDetailsEvent;

  const factory BasketEvent.addToCartProductEvent({
    required BuildContext context,
    required String productId,
  }) = _addToCartProductEvent;

  const factory BasketEvent.supplierSelectionEvent({
    required int supplierIndex,
    required BuildContext context,
    required int supplierSaleIndex,
  }) = _supplierSelectionEvent;

  const factory BasketEvent.relatedProductsEvent({
    required BuildContext context,
    required String productId,
  }) = _relatedProductsEvent;

  const factory BasketEvent.removeRelatedProductEvent() = _removeRelatedProductEvent;

  const factory BasketEvent.refreshEvent() = _refreshEvent;

  const factory BasketEvent.getPermissionList({
    required BuildContext context,
  }) = _getPermissionList;

  const factory BasketEvent.userApproveEvent({
    required BuildContext context,
  }) = _userApproveEvent;

  const factory BasketEvent.generalSettings({
    required BuildContext context,
    required BuildContext dialogContext,
    required bool isRetryLoading,
  }) = _generalSettings;

  const factory BasketEvent.updateMaintenanceEvent({
    required BuildContext context,
  }) = _updateMaintenanceEvent;

  const factory BasketEvent.getSupplierPaymentTypeEvent({
    required BuildContext context,
    required String id,
    required int index,
  }) = _getSupplierPaymentTypeEvent;

  const factory BasketEvent.updateListQuantityOfProduct({
    required BuildContext context,
    required String quantity,
    required int productListIndex,
    required int productStockUpdateIndex,
    required String productSupplierIds,
  }) = _updateListQuantityOfProductEvent;

  const factory BasketEvent.increaseListQuantityOfProduct({
    required BuildContext context,
    required int productListIndex,
    required int productStockUpdateIndex,
    required String productSupplierIds,
  }) = _increaseListQuantityOfProductEvent;

  const factory BasketEvent.decreaseListQuantityOfProduct({
    required BuildContext context,
    required int productListIndex,
    required int productStockUpdateIndex,
    required String productSupplierIds,
  }) = _decreaseListQuantityOfProductEvent;

  const factory BasketEvent.addToCartListProductEvent({
    required BuildContext context,
    required String productId,
    required int productListIndex,
    required int productStockUpdateIndex,
    required String productSupplierIds,
  }) = _addToCartListProductEvent;
}
