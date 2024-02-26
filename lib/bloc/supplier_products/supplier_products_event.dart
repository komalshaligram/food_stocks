part of 'supplier_products_bloc.dart';

@freezed
class SupplierProductsEvent with _$SupplierProductsEvent {
  const factory SupplierProductsEvent.getSupplierProductsIdEvent(
      {required String supplierId,
      required String search}) = _GetSupplierProductsIdEvent;

  const factory SupplierProductsEvent.getSupplierProductsListEvent(
      {required BuildContext context,required String searchType}) = _GetSupplierProductsListEvent;

  const factory SupplierProductsEvent.getProductDetailsEvent(
      {required BuildContext context,
      required String productId,
      required bool isBarcode
      }) = _GetProductDetailsEvent;

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
      {required BuildContext context,
      required String productId,
      }) = _AddToCartProductEvent;

  const factory SupplierProductsEvent.setCartCountEvent() = _SetCartCountEvent;

  const factory SupplierProductsEvent.updateImageIndexEvent({
    required int index,
  }) = _UpdateImageIndexEvent;

  const factory SupplierProductsEvent.toggleNoteEvent() = _ToggleNoteEvent;

  const factory SupplierProductsEvent.refreshListEvent(
      {required BuildContext context}) = _RefreshListEvent;

  const factory SupplierProductsEvent.getAllProducts(
      {required BuildContext context,required String search}) = _GetAllProductsEvent;

  const factory SupplierProductsEvent.getGridListView(
      ) = _getGridListView;
  const factory SupplierProductsEvent.changeCategoryExpansion({bool? isOpened}) =
  _ChangeCategoryExpansion;

  const factory SupplierProductsEvent.globalSearchEvent({required BuildContext context}) =
  _GlobalSearchEvent;

  const factory SupplierProductsEvent.updateGlobalSearchEvent(
      {required String search,
        required List<SearchModel> searchList}) = _UpdateGlobalSearchEvent;
}
