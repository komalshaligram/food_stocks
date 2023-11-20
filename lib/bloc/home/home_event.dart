part of 'home_bloc.dart';

@freezed
class HomeEvent with _$HomeEvent {
  const factory HomeEvent.getPreferencesDataEvent() = _getPreferencesDataEvent;

  const factory HomeEvent.getProductSalesListEvent(
      {required BuildContext context}) = _GetProductSalesListEvent;

  const factory HomeEvent.getProductDetailsEvent(
      {required BuildContext context,
      required String productId}) = _GetProductDetailsEvent;

  const factory HomeEvent.increaseQuantityOfProduct(
      {required BuildContext context}) = _IncreaseQuantityOfProduct;

  const factory HomeEvent.decreaseQuantityOfProduct(
      {required BuildContext context}) = _DecreaseQuantityOfProduct;

  const factory HomeEvent.changeNoteOfProduct({required String newNote}) =
      _ChangeNoteOfProduct;

  const factory HomeEvent.changeSupplierSelectionExpansionEvent(
      {bool? isSelectSupplier}) = _ChangeSupplierSelectionExpansionEvent;

  const factory HomeEvent.supplierSelectionEvent(
      {required int supplierIndex,
      required int supplierSaleIndex}) = _SupplierSelectionEvent;

  const factory HomeEvent.addToCartProductEvent(
      {required BuildContext context}) = _AddToCartProductEvent;

  const factory HomeEvent.updateCartCountEvent({required int cartCount}) =
      _UpdateCartCountEvent;

  const factory HomeEvent.resetCartCountEvent() = _ResetCartCountEvent;

  const factory HomeEvent.setCartCountEvent({required int cartCount}) =
      _SetCartCountEvent;

  const factory HomeEvent.getWalletRecordEvent(
      {required BuildContext context}) = _getWalletRecordEvent;

  const factory HomeEvent.getOrderCountEvent({
    required BuildContext context,
  }) = _getOrderCountEvent;
}
