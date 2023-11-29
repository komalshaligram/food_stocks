part of 'company_products_bloc.dart';

@freezed
class CompanyProductsEvent with _$CompanyProductsEvent {
  const factory CompanyProductsEvent.getCompanyProductsIdEvent(
      {required String companyId}) = _GetCompanyProductsIdEvent;

  const factory CompanyProductsEvent.getCompanyProductsListEvent(
      {required BuildContext context}) = _GetCompanyProductsListEvent;

  const factory CompanyProductsEvent.getProductDetailsEvent(
      {required BuildContext context,
      required String productId}) = _GetProductDetailsEvent;

  const factory CompanyProductsEvent.increaseQuantityOfProduct(
      {required BuildContext context}) = _IncreaseQuantityOfProduct;

  const factory CompanyProductsEvent.decreaseQuantityOfProduct(
      {required BuildContext context}) = _DecreaseQuantityOfProduct;

  const factory CompanyProductsEvent.changeNoteOfProduct(
      {required String newNote}) = _ChangeNoteOfProduct;

  const factory CompanyProductsEvent.changeSupplierSelectionExpansionEvent(
      {bool? isSelectSupplier}) = _ChangeSupplierSelectionExpansionEvent;

  const factory CompanyProductsEvent.supplierSelectionEvent(
      {required int supplierIndex,
      required int supplierSaleIndex}) = _SupplierSelectionEvent;

  const factory CompanyProductsEvent.addToCartProductEvent(
      {required BuildContext context}) = _AddToCartProductEvent;

  const factory CompanyProductsEvent.setCartCountEvent() = _SetCartCountEvent;

  const factory CompanyProductsEvent.updateImageIndexEvent({
    required int index,
  }) = _UpdateImageIndexEvent;
}
