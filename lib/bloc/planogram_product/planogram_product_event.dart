part of 'planogram_product_bloc.dart';

@freezed
class PlanogramProductEvent with _$PlanogramProductEvent {
  const factory PlanogramProductEvent.getPreferencesDataEvent() = _getPreferencesDataEvent;

  const factory PlanogramProductEvent.getPlanogramProductsEvent({required PlanogramDatum planogram, required BuildContext context}) = _getPlanogramProductsEvent;

  const factory PlanogramProductEvent.getProductDetailsEvent({
    required BuildContext context,
    required String productId,
    required bool isBarcode,
    required int productListIndex,
  }) = _getProductDetailsEvent;

  const factory PlanogramProductEvent.increaseQuantityOfProduct({required BuildContext context}) = _increaseQuantityOfProduct;

  const factory PlanogramProductEvent.decreaseQuantityOfProduct({required BuildContext context}) = _decreaseQuantityOfProduct;

  const factory PlanogramProductEvent.updateQuantityOfProduct({required BuildContext context, required String quantity}) = _updateQuantityOfProduct;

  const factory PlanogramProductEvent.changeNoteOfProduct({required String newNote}) = _changeNoteOfProduct;

  const factory PlanogramProductEvent.changeSupplierSelectionExpansionEvent({bool? isSelectSupplier}) = _changeSupplierSelectionExpansionEvent;

  const factory PlanogramProductEvent.supplierSelectionEvent({
    required int supplierIndex,
    required BuildContext context,
    required int supplierSaleIndex,
  }) = _supplierSelectionEvent;

  const factory PlanogramProductEvent.addToCartProductEvent({required BuildContext context, required String productId}) = _addToCartProductEvent;

  const factory PlanogramProductEvent.setCartCountEvent() = _setCartCountEvent;

  const factory PlanogramProductEvent.updateImageIndexEvent({required int index}) = _updateImageIndexEvent;

  const factory PlanogramProductEvent.toggleNoteEvent() = _ToggleNoteEvent;

  const factory PlanogramProductEvent.isCategoryEvent({required bool isSubCategory}) = _isCategoryEvent;

  const factory PlanogramProductEvent.getPlanogramByIdEvent({required BuildContext context}) = _getPlanogramByIdEvent;

  const factory PlanogramProductEvent.getPlanogramAllProductEvent({required BuildContext context}) = _getPlanogramAllProductEvent;

  const factory PlanogramProductEvent.getSubCategoryProductEvent({required BuildContext context}) = _getSubCategoryProductEvent;

  const factory PlanogramProductEvent.getCartCountEvent() = _getCartCountEvent;

  const factory PlanogramProductEvent.getGridListView() = _getGridListView;

  const factory PlanogramProductEvent.changeCategoryExpansion({bool? isOpened}) = _changeCategoryExpansion;

  const factory PlanogramProductEvent.globalSearchEvent({required BuildContext context}) = _globalSearchEvent;

  const factory PlanogramProductEvent.updateGlobalSearchEvent({required String search, required List<SearchModel> searchList}) = _updateGlobalSearchEvent;

  const factory PlanogramProductEvent.getProductCategoriesListEvent({required BuildContext context}) = _getProductCategoriesListEvent;

  const factory PlanogramProductEvent.relatedProductsEvent({required BuildContext context, required String productId}) = _relatedProductsEvent;

  const factory PlanogramProductEvent.removeRelatedProductEvent() = _removeRelatedProductEvent;

  const factory PlanogramProductEvent.getPermissionList({required BuildContext context}) = _getPermissionList;

  const factory PlanogramProductEvent.userApproveEvent({required BuildContext context}) = _userApproveEvent;

  const factory PlanogramProductEvent.updateListQuantityOfProduct({
    required BuildContext context,
    required String quantity,
    required int productListIndex,
    required int productStockUpdateIndex,
    required String productSupplierIds,
  }) = _updateListQuantityOfProductEvent;

  const factory PlanogramProductEvent.increaseListQuantityOfProduct({
    required BuildContext context,
    required int productListIndex,
    required int productStockUpdateIndex,
    required String productSupplierIds,
  }) = _increaseListQuantityOfProductEvent;

  const factory PlanogramProductEvent.decreaseListQuantityOfProduct({
    required BuildContext context,
    required int productListIndex,
    required int productStockUpdateIndex,
    required String productSupplierIds,
  }) = _decreaseListQuantityOfProductEvent;

  const factory PlanogramProductEvent.addToCartListProductEvent({
    required BuildContext context,
    required String productId,
    required int productListIndex,
    required int productStockUpdateIndex,
    required String productSupplierIds,
  }) = _addToCartListProductEvent;
}
