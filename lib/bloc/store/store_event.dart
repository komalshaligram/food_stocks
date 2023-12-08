part of 'store_bloc.dart';

@freezed
class StoreEvent with _$StoreEvent {
  const factory StoreEvent.changeCategoryExpansion({bool? isOpened}) =
      _ChangeCategoryExpansion;

  const factory StoreEvent.getProductCategoriesListEvent(
      {required BuildContext context}) = _GetProductCategoriesListEvent;

  const factory StoreEvent.getProductSalesListEvent(
      {required BuildContext context}) = _GetProductSalesListEvent;

  const factory StoreEvent.getRecommendationProductsListEvent(
      {required BuildContext context}) = _GetRecommendationProductsListEvent;

  const factory StoreEvent.changeSearchListEvent(
      {required List<SearchModel> newSearchList}) = _ChangeSearchListEvent;

  const factory StoreEvent.getSuppliersListEvent(
      {required BuildContext context}) = _GetSuppliersListEvent;

  const factory StoreEvent.getCompaniesListEvent(
      {required BuildContext context}) = _GetCompaniesListEvent;

  const factory StoreEvent.getProductDetailsEvent(
      {required BuildContext context,
      required String productId,
      bool? isBarcode}) = _GetProductDetailsEvent;

  const factory StoreEvent.increaseQuantityOfProduct(
      {required BuildContext context}) = _IncreaseQuantityOfProduct;

  const factory StoreEvent.decreaseQuantityOfProduct(
      {required BuildContext context}) = _DecreaseQuantityOfProduct;

  const factory StoreEvent.changeNoteOfProduct({required String newNote}) =
      _ChangeNoteOfProduct;

  const factory StoreEvent.changeSupplierSelectionExpansionEvent(
      {bool? isSelectSupplier}) = _ChangeSupplierSelectionExpansionEvent;

  const factory StoreEvent.supplierSelectionEvent(
      {required int supplierIndex,
      required BuildContext context,
      required int supplierSaleIndex}) = _SupplierSelectionEvent;

  const factory StoreEvent.addToCartProductEvent(
      {required BuildContext context}) = _AddToCartProductEvent;

  const factory StoreEvent.setCartCountEvent() = _SetCartCountEvent;

  const factory StoreEvent.globalSearchEvent({required BuildContext context}) =
      _GlobalSearchEvent;

  const factory StoreEvent.resetGlobalSearchEvent() = _ResetGlobalSearchEvent;

  const factory StoreEvent.updateImageIndexEvent({
    required int index,
  }) = _UpdateImageIndexEvent;

  const factory StoreEvent.updateGlobalSearchEvent(
      {required String search,
      required List<SearchModel> searchList}) = _UpdateGlobalSearchEvent;

  const factory StoreEvent.toggleNoteEvent({required bool isBarcode}) =
      _ToggleNoteEvent;
}
