part of 'product_sale_bloc.dart';

@freezed
class ProductSaleEvent with _$ProductSaleEvent {
  const factory ProductSaleEvent.getProductSalesListEvent(
      {required BuildContext context}) = _GetProductSalesListEvent;

  const factory ProductSaleEvent.getProductDetailsEvent(
      {required BuildContext context,
      required String productId}) = _GetProductDetailsEvent;

  const factory ProductSaleEvent.increaseQuantityOfProduct(
      {required BuildContext context}) = _IncreaseQuantityOfProduct;

  const factory ProductSaleEvent.decreaseQuantityOfProduct(
      {required BuildContext context}) = _DecreaseQuantityOfProduct;

  const factory ProductSaleEvent.changeNoteOfProduct(
      {required String newNote}) = _ChangeNoteOfProduct;

  const factory ProductSaleEvent.changeSupplierSelectionExpansionEvent(
      {bool? isSelectSupplier}) = _ChangeSupplierSelectionExpansionEvent;

  const factory ProductSaleEvent.supplierSelectionEvent(
      {required int supplierIndex,
      required BuildContext context,
      required int supplierSaleIndex}) = _SupplierSelectionEvent;

  const factory ProductSaleEvent.addToCartProductEvent(
      {required BuildContext context}) = _AddToCartProductEvent;

  const factory ProductSaleEvent.setCartCountEvent() = _SetCartCountEvent;

  const factory ProductSaleEvent.updateImageIndexEvent({
    required int index,
  }) = _UpdateImageIndexEvent;

  const factory ProductSaleEvent.setSearchEvent({required String search}) =
      _SetSearchEvent;

  const factory ProductSaleEvent.toggleNoteEvent() = _ToggleNoteEvent;

  const factory ProductSaleEvent.refreshListEvent(
      {required BuildContext context}) = _RefreshListEvent;
}
