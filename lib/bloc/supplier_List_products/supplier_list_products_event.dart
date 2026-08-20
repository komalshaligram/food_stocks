part of 'supplier_list_products_bloc.dart';

@freezed
class SupplierListProductsEvent with _$SupplierListProductsEvent {
  const factory SupplierListProductsEvent.getPreferencesDataEvent() = _getPreferencesDataEvent;

  const factory SupplierListProductsEvent.getSupplierProductsIdEvent({required String supplierId, required String search}) =
      _getSupplierProductsIdEvent;

  const factory SupplierListProductsEvent.getSupplierProductsListEvent({required BuildContext context, required String searchType, String? brandId}) =
      _getSupplierProductsListEvent;

  const factory SupplierListProductsEvent.selectBrandEvent({required BuildContext context, required String brandId}) = _selectBrandEvent;

  const factory SupplierListProductsEvent.selectCategoryEvent({required BuildContext context, required String categoryId}) = _selectCategoryEvent;

  const factory SupplierListProductsEvent.selectSubCategoryEvent({required BuildContext context, required String subCategoryId}) =
      _selectSubCategoryEvent;

  const factory SupplierListProductsEvent.getProductDetailsEvent(
      {required BuildContext context, required String productId, required bool isBarcode, required int productListIndex}) = _getProductDetailsEvent;

  const factory SupplierListProductsEvent.increaseQuantityOfProduct({required BuildContext context}) = _increaseQuantityOfProduct;

  const factory SupplierListProductsEvent.decreaseQuantityOfProduct({required BuildContext context}) = _decreaseQuantityOfProduct;

  const factory SupplierListProductsEvent.updateQuantityOfProduct({required BuildContext context, required String quantity}) =
      _updateQuantityOfProduct;

  const factory SupplierListProductsEvent.supplierSelectionEvent(
      {required int supplierIndex, required BuildContext context, required int supplierSaleIndex}) = _supplierSelectionEvent;

  const factory SupplierListProductsEvent.addToCartProductEvent({required BuildContext context, required String productId}) = _addToCartProductEvent;

  const factory SupplierListProductsEvent.setCartCountEvent() = _setCartCountEvent;

  const factory SupplierListProductsEvent.refreshListEvent({required BuildContext context}) = _refreshListEvent;

  const factory SupplierListProductsEvent.getAllProducts({required BuildContext context, required String search}) = _getAllProductsEvent;

  const factory SupplierListProductsEvent.getGridListView() = _getGridListView;

  const factory SupplierListProductsEvent.changeCategoryExpansion({bool? isOpened}) = _changeCategoryExpansion;

  const factory SupplierListProductsEvent.globalSearchEvent({required BuildContext context}) = _globalSearchEvent;

  const factory SupplierListProductsEvent.updateGlobalSearchEvent({required String search, required List<SearchModel> searchList}) =
      _updateGlobalSearchEvent;

  const factory SupplierListProductsEvent.relatedProductsEvent({required BuildContext context, required String productId}) = _relatedProductsEvent;
  const factory SupplierListProductsEvent.removeRelatedProductEvent() = _removeRelatedProductEvent;

  const factory SupplierListProductsEvent.getPermissionList({required BuildContext context}) = _getPermissionList;

  const factory SupplierListProductsEvent.userApproveEvent({required BuildContext context}) = _userApproveEvent;

  const factory SupplierListProductsEvent.updateListQuantityOfProduct(
      {required BuildContext context,
      required String quantity,
      required int productListIndex,
      required int productStockUpdateIndex,
      required String productSupplierIds}) = _updateListQuantityOfProductEvent;

  const factory SupplierListProductsEvent.increaseListQuantityOfProduct(
      {required BuildContext context,
      required int productListIndex,
      required int productStockUpdateIndex,
      required String productSupplierIds}) = _increaseListQuantityOfProductEvent;

  const factory SupplierListProductsEvent.decreaseListQuantityOfProduct(
      {required BuildContext context,
      required int productListIndex,
      required int productStockUpdateIndex,
      required String productSupplierIds}) = _decreaseListQuantityOfProductEvent;

  const factory SupplierListProductsEvent.addToCartListProductEvent(
      {required BuildContext context,
      required String productId,
      required int productListIndex,
      required int productStockUpdateIndex,
      required String productSupplierIds}) = _addToCartListProductEvent;

  const factory SupplierListProductsEvent.getCartCountEvent() = _getCartCountEvent;
  const factory SupplierListProductsEvent.getCartCountNoEvent({required BuildContext context}) = _getCartCountNoEvent;

  const factory SupplierListProductsEvent.applyListCartQuantitiesEvent({required Map<String, int> cartQuantities}) = _applyListCartQuantitiesEvent;

  const factory SupplierListProductsEvent.getSupplierDeliveryScheduleEvent({required BuildContext context}) = _getSupplierDeliveryScheduleEvent;

  const factory SupplierListProductsEvent.getSupplierAppInfoEvent({required BuildContext context}) = _getSupplierAppInfoEvent;

  const factory SupplierListProductsEvent.applySortOptionEvent({required BuildContext context, required ProductSortOption option}) =
      _applySortOptionEvent;
}
