part of 'recommendation_products_bloc.dart';

@freezed
class RecommendationProductsEvent with _$RecommendationProductsEvent {
  const factory RecommendationProductsEvent.getPreferencesDataEvent() =
      _getPreferencesDataEvent;

  const factory RecommendationProductsEvent.getRecommendationProductsEvent(
      {required BuildContext context}) = _getRecommendationProductsEvent;

  const factory RecommendationProductsEvent.getProductDetailsEvent({
    required BuildContext context,
    required String productId,
    required bool isBarcode,
    required int productListIndex,
  }) = _getProductDetailsEvent;

  const factory RecommendationProductsEvent.increaseQuantityOfProduct(
      {required BuildContext context}) = _increaseQuantityOfProduct;

  const factory RecommendationProductsEvent.decreaseQuantityOfProduct(
      {required BuildContext context}) = _decreaseQuantityOfProduct;

  const factory RecommendationProductsEvent.updateQuantityOfProduct(
      {required BuildContext context,
      required String quantity}) = _updateQuantityOfProduct;

  const factory RecommendationProductsEvent.changeNoteOfProduct(
      {required String newNote}) = _changeNoteOfProduct;

  const factory RecommendationProductsEvent.changeSupplierSelectionExpansionEvent(
      {bool? isSelectSupplier}) = _changeSupplierSelectionExpansionEvent;

  const factory RecommendationProductsEvent.supplierSelectionEvent(
      {required int supplierIndex,
      required BuildContext context,
      required int supplierSaleIndex}) = _supplierSelectionEvent;

  const factory RecommendationProductsEvent.addToCartProductEvent(
      {required BuildContext context,
      required String productId}) = _addToCartProductEvent;

  const factory RecommendationProductsEvent.setCartCountEvent() =
      _setCartCountEvent;

  const factory RecommendationProductsEvent.updateImageIndexEvent(
      {required int index}) = _updateImageIndexEvent;

  const factory RecommendationProductsEvent.toggleNoteEvent() =
      _toggleNoteEvent;

  const factory RecommendationProductsEvent.refreshListEvent(
      {required BuildContext context}) = _refreshListEvent;

  const factory RecommendationProductsEvent.getCartCountEvent() =
      _getCartCountEvent;

  const factory RecommendationProductsEvent.getGridListView() =
      _getGridListView;

  const factory RecommendationProductsEvent.changeCategoryExpansion(
      {bool? isOpened}) = _changeCategoryExpansion;

  const factory RecommendationProductsEvent.globalSearchEvent(
      {required BuildContext context}) = _globalSearchEvent;

  const factory RecommendationProductsEvent.updateGlobalSearchEvent(
      {required String search,
      required List<SearchModel> searchList}) = _updateGlobalSearchEvent;

  const factory RecommendationProductsEvent.getProductCategoriesListEvent(
      {required BuildContext context}) = _getProductCategoriesListEvent;

  const factory RecommendationProductsEvent.relatedProductsEvent(
      {required BuildContext context,
      required String productId}) = _relatedProductsEvent;

  const factory RecommendationProductsEvent.removeRelatedProductEvent() =
      _removeRelatedProductEvent;

  const factory RecommendationProductsEvent.getPermissionList(
      {required BuildContext context}) = _getPermissionList;

  const factory RecommendationProductsEvent.userApproveEvent(
      {required BuildContext context}) = _userApproveEvent;

  const factory RecommendationProductsEvent.updateListQuantityOfProduct({
    required BuildContext context,
    required String quantity,
    required int productListIndex,
    required int productStockUpdateIndex,
    required String productSupplierIds,
  }) = _updateListQuantityOfProductEvent;

  const factory RecommendationProductsEvent.increaseListQuantityOfProduct({
    required BuildContext context,
    required int productListIndex,
    required int productStockUpdateIndex,
    required String productSupplierIds,
  }) = _increaseListQuantityOfProductEvent;

  const factory RecommendationProductsEvent.decreaseListQuantityOfProduct({
    required BuildContext context,
    required int productListIndex,
    required int productStockUpdateIndex,
    required String productSupplierIds,
  }) = _decreaseListQuantityOfProductEvent;

  const factory RecommendationProductsEvent.addToCartListProductEvent({
    required BuildContext context,
    required String productId,
    required int productListIndex,
    required int productStockUpdateIndex,
    required String productSupplierIds,
  }) = _addToCartListProductEvent;

  const factory RecommendationProductsEvent.getCartCountNoEvent(
      {required BuildContext context}) = _getCartCountNoEvent;
}
