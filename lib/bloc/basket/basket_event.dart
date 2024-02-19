part of 'basket_bloc.dart';

@freezed
class BasketEvent with _$BasketEvent {
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
  }) = _removeCartProductEvent;

  const factory BasketEvent.getAllCartEvent({required BuildContext context}) =
      _getAllCartEvent;

  const factory BasketEvent.clearCartEvent({required BuildContext context}) =
      _clearCartEvent;


  const factory BasketEvent.setCartCountEvent({required bool isClearCart}) =_SetCartCountEvent;
  const factory BasketEvent.updateImageIndexEvent({required int index}) =_updateImageIndexEvent;
  const factory BasketEvent.refreshListEvent({required BuildContext context}) =_refreshListEvent;

  const factory BasketEvent.orderSendEvent({
    required BuildContext context,
  }) = _orderSendEvent;
  const factory BasketEvent.increaseQuantityOfProduct(
      {required BuildContext context}) = _IncreaseQuantityOfProduct;

  const factory BasketEvent.decreaseQuantityOfProduct(
      {required BuildContext context}) = _DecreaseQuantityOfProduct;

  const factory BasketEvent.updateQuantityOfProduct(
      {required BuildContext context,
        required String quantity}) = _UpdateQuantityOfProduct;

  const factory BasketEvent.getProductDetailsEvent(
      {required BuildContext context,
        required bool isBarcode,
        required String productId}) = _GetProductDetailsEvent;

  const factory BasketEvent.addToCartProductEvent(
      {required BuildContext context}) = _AddToCartProductEvent;

  const factory BasketEvent.supplierSelectionEvent(
      {required int supplierIndex,
        required BuildContext context,
        required int supplierSaleIndex}) = _SupplierSelectionEvent;
}
