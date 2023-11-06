part of 'supplier_products_bloc.dart';

@freezed
class SupplierProductsEvent with _$SupplierProductsEvent {
  const factory SupplierProductsEvent.getSupplierProductsIdEvent(
      {required String supplierId}) = _GetSupplierProductsIdEvent;

  const factory SupplierProductsEvent.getSupplierProductsListEvent(
      {required BuildContext context}) = _GetSupplierProductsListEvent;

  const factory SupplierProductsEvent.getProductDetailsEvent(
      {required BuildContext context,
      required String productId}) = _GetProductDetailsEvent;

  const factory SupplierProductsEvent.increaseQuantityOfProduct(
      {required BuildContext context}) = _IncreaseQuantityOfProduct;

  const factory SupplierProductsEvent.decreaseQuantityOfProduct(
      {required BuildContext context}) = _DecreaseQuantityOfProduct;

  const factory SupplierProductsEvent.changeNoteOfProduct(
      {required String newNote}) = _ChangeNoteOfProduct;
}
