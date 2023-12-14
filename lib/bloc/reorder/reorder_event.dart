part of 'reorder_bloc.dart';

@freezed
class ReorderEvent with _$ReorderEvent {
  const factory ReorderEvent.getPreviousOrderProductsEvent(
      {required BuildContext context}) = _GetPreviousOrderProductsEvent;

  const factory ReorderEvent.getProductDetailsEvent(
      {required BuildContext context,
      required String productId}) = _GetProductDetailsEvent;

  const factory ReorderEvent.increaseQuantityOfProduct(
      {required BuildContext context}) = _IncreaseQuantityOfProduct;

  const factory ReorderEvent.decreaseQuantityOfProduct(
      {required BuildContext context}) = _DecreaseQuantityOfProduct;

  const factory ReorderEvent.updateQuantityOfProduct(
      {required BuildContext context,
      required String quantity}) = _UpdateQuantityOfProduct;

  const factory ReorderEvent.changeNoteOfProduct({required String newNote}) =
      _ChangeNoteOfProduct;

  const factory ReorderEvent.changeSupplierSelectionExpansionEvent(
      {bool? isSelectSupplier}) = _ChangeSupplierSelectionExpansionEvent;

  const factory ReorderEvent.supplierSelectionEvent(
      {required int supplierIndex,
      required BuildContext context,
      required int supplierSaleIndex}) = _SupplierSelectionEvent;

  const factory ReorderEvent.addToCartProductEvent(
      {required BuildContext context}) = _AddToCartProductEvent;

  const factory ReorderEvent.setCartCountEvent() = _SetCartCountEvent;

  const factory ReorderEvent.updateImageIndexEvent({
    required int index,
  }) = _UpdateImageIndexEvent;

  const factory ReorderEvent.toggleNoteEvent() = _ToggleNoteEvent;

  const factory ReorderEvent.refreshListEvent({required BuildContext context}) =
      _RefreshListEvent;
}
