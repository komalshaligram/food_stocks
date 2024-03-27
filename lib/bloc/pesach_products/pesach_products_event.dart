part of 'pesach_products_bloc.dart';

@freezed
class PesachProductsEvent with _$PesachProductsEvent {
  const factory PesachProductsEvent.getSupplierProductsIdEvent(
      {required String supplierId,
      required String search}) = _GetSupplierProductsIdEvent;

  const factory PesachProductsEvent.getSupplierProductsListEvent(
      {required BuildContext context,required String searchType}) = _GetSupplierProductsListEvent;

  const factory PesachProductsEvent.getProductDetailsEvent(
      {required BuildContext context,
      required String productId,
      required bool isBarcode
      }) = _GetProductDetailsEvent;

  const factory PesachProductsEvent.increaseQuantityOfProduct(
      {required BuildContext context}) = _IncreaseQuantityOfProduct;

  const factory PesachProductsEvent.decreaseQuantityOfProduct(
      {required BuildContext context}) = _DecreaseQuantityOfProduct;

  const factory PesachProductsEvent.updateQuantityOfProduct(
      {required BuildContext context,
      required String quantity}) = _UpdateQuantityOfProduct;

  const factory PesachProductsEvent.changeNoteOfProduct(
      {required String newNote}) = _ChangeNoteOfProduct;

  const factory PesachProductsEvent.changeSupplierSelectionExpansionEvent(
      {bool? isSelectSupplier}) = _ChangeSupplierSelectionExpansionEvent;

  const factory PesachProductsEvent.supplierSelectionEvent(
      {required int supplierIndex,
      required BuildContext context,
      required int supplierSaleIndex}) = _SupplierSelectionEvent;

  const factory PesachProductsEvent.addToCartProductEvent(
      {required BuildContext context,
      required String productId,
      }) = _AddToCartProductEvent;

  const factory PesachProductsEvent.setCartCountEvent() = _SetCartCountEvent;

  const factory PesachProductsEvent.updateImageIndexEvent({
    required int index,
  }) = _UpdateImageIndexEvent;

  const factory PesachProductsEvent.toggleNoteEvent() = _ToggleNoteEvent;

  const factory PesachProductsEvent.refreshListEvent(
      {required BuildContext context}) = _RefreshListEvent;

  const factory PesachProductsEvent.getAllProducts(
      {required BuildContext context,required String search}) = _GetAllProductsEvent;

  const factory PesachProductsEvent.getGridListView(
      ) = _getGridListView;
  const factory PesachProductsEvent.changeCategoryExpansion({bool? isOpened}) =
  _ChangeCategoryExpansion;

  const factory PesachProductsEvent.globalSearchEvent({required BuildContext context}) =
  _GlobalSearchEvent;

  const factory PesachProductsEvent.updateGlobalSearchEvent(
      {required String search,
        required List<SearchModel> searchList}) = _UpdateGlobalSearchEvent;

  const factory PesachProductsEvent.RelatedProductsEvent({required BuildContext context,required String productId}) = _RelatedProductsEvent;
  const factory PesachProductsEvent.RemoveRelatedProductEvent() = _RemoveRelatedProductEvent;

}
