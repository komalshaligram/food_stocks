part of 'company_products_bloc.dart';

@freezed
class CompanyProductsEvent with _$CompanyProductsEvent {
  const factory CompanyProductsEvent.getCompanyProductsIdEvent(
      {required String companyId}) = _GetCompanyProductsIdEvent;

  const factory CompanyProductsEvent.getCompanyProductsListEvent(
      {required BuildContext context}) = _GetCompanyProductsListEvent;

  const factory CompanyProductsEvent.getProductDetailsEvent(
      {required BuildContext context,
      required String productId,
      required bool isBarcode
      }) = _GetProductDetailsEvent;

  const factory CompanyProductsEvent.increaseQuantityOfProduct(
      {required BuildContext context}) = _IncreaseQuantityOfProduct;

  const factory CompanyProductsEvent.decreaseQuantityOfProduct(
      {required BuildContext context}) = _DecreaseQuantityOfProduct;

  const factory CompanyProductsEvent.updateQuantityOfProduct(
      {required BuildContext context,
      required String quantity}) = _UpdateQuantityOfProduct;

  const factory CompanyProductsEvent.changeNoteOfProduct(
      {required String newNote}) = _ChangeNoteOfProduct;

  const factory CompanyProductsEvent.changeSupplierSelectionExpansionEvent(
      {bool? isSelectSupplier}) = _ChangeSupplierSelectionExpansionEvent;

  const factory CompanyProductsEvent.supplierSelectionEvent(
      {required int supplierIndex,
      required BuildContext context,
      required int supplierSaleIndex}) = _SupplierSelectionEvent;

  const factory CompanyProductsEvent.addToCartProductEvent(
      {required BuildContext context}) = _AddToCartProductEvent;

  const factory CompanyProductsEvent.setCartCountEvent() = _SetCartCountEvent;

  const factory CompanyProductsEvent.updateImageIndexEvent({
    required int index,
  }) = _UpdateImageIndexEvent;

  const factory CompanyProductsEvent.toggleNoteEvent() = _ToggleNoteEvent;

  const factory CompanyProductsEvent.refreshListEvent(
      {required BuildContext context}) = _RefreshListEvent;


  const factory CompanyProductsEvent.getCartCountEvent(
      ) = _getCartCountEvent;

  const factory CompanyProductsEvent.getGridListView(
      ) = _getGridListView;

  const factory CompanyProductsEvent.changeCategoryExpansion({bool? isOpened}) =
  _ChangeCategoryExpansion;

  const factory CompanyProductsEvent.globalSearchEvent({required BuildContext context}) =
  _GlobalSearchEvent;

  const factory CompanyProductsEvent.updateGlobalSearchEvent(
      {required String search,
        required List<SearchModel> searchList}) = _UpdateGlobalSearchEvent;

  const factory CompanyProductsEvent.getProductCategoriesListEvent(
      {required BuildContext context}) = _GetProductCategoriesListEvent;
}
