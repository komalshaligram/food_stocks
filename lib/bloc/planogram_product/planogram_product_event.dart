part of 'planogram_product_bloc.dart';

@freezed
class PlanogramProductEvent with _$PlanogramProductEvent {
  const factory PlanogramProductEvent.getPlanogramProductsEvent(
      {required Datum planogram}) = _GetPlanogramProductsEvent;

  const factory PlanogramProductEvent.getProductDetailsEvent(
      {required BuildContext context,
      required String productId}) = _GetProductDetailsEvent;

  const factory PlanogramProductEvent.increaseQuantityOfProduct(
      {required BuildContext context}) = _IncreaseQuantityOfProduct;

  const factory PlanogramProductEvent.decreaseQuantityOfProduct(
      {required BuildContext context}) = _DecreaseQuantityOfProduct;

  const factory PlanogramProductEvent.changeNoteOfProduct(
      {required String newNote}) = _ChangeNoteOfProduct;

  const factory PlanogramProductEvent.changeSupplierSelectionExpansionEvent(
      {bool? isSelectSupplier}) = _ChangeSupplierSelectionExpansionEvent;

  const factory PlanogramProductEvent.supplierSelectionEvent(
      {required int supplierIndex,
      required int supplierSaleIndex}) = _SupplierSelectionEvent;

  const factory PlanogramProductEvent.addToCartProductEvent(
      {required BuildContext context}) = _AddToCartProductEvent;

  const factory PlanogramProductEvent.setCartCountEvent() = _SetCartCountEvent;

  const factory PlanogramProductEvent.updateImageIndexEvent({
    required int index,
  }) = _UpdateImageIndexEvent;
}
