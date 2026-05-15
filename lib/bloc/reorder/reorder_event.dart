part of 'reorder_bloc.dart';

@freezed
class ReorderEvent with _$ReorderEvent {
  const factory ReorderEvent.getPreferencesDataEvent() = _getPreferencesDataEvent;

  const factory ReorderEvent.getPreviousOrderProductsEvent({required BuildContext context}) = _getPreviousOrderProductsEvent;

  const factory ReorderEvent.getProductDetailsEvent({
    required BuildContext context,
    required String productId,
    required bool isBarcode,
    required int productListIndex,
  }) = _getProductDetailsEvent;

  const factory ReorderEvent.increaseQuantityOfProduct({required BuildContext context}) = _increaseQuantityOfProduct;

  const factory ReorderEvent.decreaseQuantityOfProduct({required BuildContext context}) = _decreaseQuantityOfProduct;

  const factory ReorderEvent.updateQuantityOfProduct({required BuildContext context, required String quantity}) = _updateQuantityOfProduct;

  const factory ReorderEvent.changeNoteOfProduct({required String newNote}) = _changeNoteOfProduct;

  const factory ReorderEvent.changeSupplierSelectionExpansionEvent({bool? isSelectSupplier}) = _changeSupplierSelectionExpansionEvent;

  const factory ReorderEvent.supplierSelectionEvent({required int supplierIndex, required BuildContext context, required int supplierSaleIndex}) = _supplierSelectionEvent;

  const factory ReorderEvent.addToCartProductEvent({required BuildContext context, required String productId}) = _addToCartProductEvent;

  const factory ReorderEvent.setCartCountEvent() = _setCartCountEvent;

  const factory ReorderEvent.updateImageIndexEvent({required int index}) = _updateImageIndexEvent;

  const factory ReorderEvent.toggleNoteEvent() = _toggleNoteEvent;

  const factory ReorderEvent.refreshListEvent({required BuildContext context}) = _refreshListEvent;

  const factory ReorderEvent.getCartCountEvent() = _getCartCountEvent;

  const factory ReorderEvent.getGridListView() = _getGridListView;

  const factory ReorderEvent.changeCategoryExpansion({bool? isOpened}) = _changeCategoryExpansion;

  const factory ReorderEvent.globalSearchEvent({required BuildContext context}) = _globalSearchEvent;

  const factory ReorderEvent.updateGlobalSearchEvent({required String search, required List<SearchModel> searchList}) = _updateGlobalSearchEvent;

  const factory ReorderEvent.getProductCategoriesListEvent({required BuildContext context}) = _getProductCategoriesListEvent;

  const factory ReorderEvent.relatedProductsEvent({required BuildContext context, required String productId}) = _relatedProductsEvent;

  const factory ReorderEvent.removeRelatedProductEvent() = _removeRelatedProductEvent;

  const factory ReorderEvent.getPermissionList({required BuildContext context}) = _getPermissionList;

  const factory ReorderEvent.filterEvent({required BuildContext context}) = _filterEvent;

  const factory ReorderEvent.sortingEvent({required BuildContext context, required String sortField}) = _sortingEvent;

  const factory ReorderEvent.selectFilterFieldEvent({required BuildContext context, required int mainIndex, required int subIndex, required int subCatIndex}) = _selectFilterFieldEvent;

  const factory ReorderEvent.applyFilterEvent({required BuildContext context}) = _applyFilterEvent;

  const factory ReorderEvent.clearFilterEvent({required BuildContext context}) = _clearFilterEvent;

  const factory ReorderEvent.expansionChangeEvent({required bool isExpansionChanged, required int mainIndex, required int subIndex}) = _expansionChangeEvent;

  const factory ReorderEvent.userApproveEvent({required BuildContext context}) = _userApproveEvent;

  const factory ReorderEvent.updateListQuantityOfProduct({
    required BuildContext context,
    required String quantity,
    required int productListIndex,
    required int productStockUpdateIndex,
    required String productSupplierIds,
  }) = _updateListQuantityOfProductEvent;

  const factory ReorderEvent.increaseListQuantityOfProduct({
    required BuildContext context,
    required int productListIndex,
    required int productStockUpdateIndex,
    required String productSupplierIds,
  }) = _increaseListQuantityOfProductEvent;

  const factory ReorderEvent.decreaseListQuantityOfProduct({
    required BuildContext context,
    required int productListIndex,
    required int productStockUpdateIndex,
    required String productSupplierIds,
  }) = _decreaseListQuantityOfProductEvent;

  const factory ReorderEvent.addToCartListProductEvent({
    required BuildContext context,
    required String productId,
    required int productListIndex,
    required int productStockUpdateIndex,
    required String productSupplierIds,
  }) = _addToCartListProductEvent;

  const factory ReorderEvent.getCartCountNoEvent({required BuildContext context}) = _getCartCountNoEvent;
}
