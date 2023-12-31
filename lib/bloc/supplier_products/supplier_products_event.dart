part of 'supplier_products_bloc.dart';

@freezed
class SupplierProductsEvent with _$SupplierProductsEvent {
  const factory SupplierProductsEvent.getSupplierProductsIdEvent(
      {required String supplierId,
      required String search}) = _GetSupplierProductsIdEvent;

  const factory SupplierProductsEvent.getSupplierProductsListEvent(
      {required BuildContext context}) = _GetSupplierProductsListEvent;

  const factory SupplierProductsEvent.getProductDetailsEvent(
      {required BuildContext context,
      required String productId}) = _GetProductDetailsEvent;

  const factory SupplierProductsEvent.increaseQuantityOfProduct(
      {required BuildContext context}) = _IncreaseQuantityOfProduct;

  const factory SupplierProductsEvent.decreaseQuantityOfProduct(
      {required BuildContext context}) = _DecreaseQuantityOfProduct;

  const factory SupplierProductsEvent.updateQuantityOfProduct(
      {required BuildContext context,
      required String quantity}) = _UpdateQuantityOfProduct;

  const factory SupplierProductsEvent.changeNoteOfProduct(
      {required String newNote}) = _ChangeNoteOfProduct;

  const factory SupplierProductsEvent.changeSupplierSelectionExpansionEvent(
      {bool? isSelectSupplier}) = _ChangeSupplierSelectionExpansionEvent;

  const factory SupplierProductsEvent.supplierSelectionEvent(
      {required int supplierIndex,
      required BuildContext context,
      required int supplierSaleIndex}) = _SupplierSelectionEvent;

  const factory SupplierProductsEvent.addToCartProductEvent(
      {required BuildContext context}) = _AddToCartProductEvent;

  const factory SupplierProductsEvent.setCartCountEvent() = _SetCartCountEvent;

  const factory SupplierProductsEvent.updateImageIndexEvent({
    required int index,
  }) = _UpdateImageIndexEvent;

  const factory SupplierProductsEvent.toggleNoteEvent() = _ToggleNoteEvent;

  const factory SupplierProductsEvent.refreshListEvent(
      {required BuildContext context}) = _RefreshListEvent;
}
