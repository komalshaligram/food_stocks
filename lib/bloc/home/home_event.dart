part of 'home_bloc.dart';

@freezed
class HomeEvent with _$HomeEvent {
  const factory HomeEvent.getPreferencesDataEvent() = _getPreferencesDataEvent;

  const factory HomeEvent.getProductSalesListEvent({required BuildContext context}) = _getProductSalesListEvent;

  const factory HomeEvent.getProductDetailsEvent({
    required BuildContext context,
    required bool isBarcode,
    required String productId,
    required int productListIndex,
  }) = _getProductDetailsEvent;

  const factory HomeEvent.increaseQuantityOfProduct({
    required BuildContext context,
  }) = _increaseQuantityOfProduct;

  const factory HomeEvent.generalSettings({required BuildContext context, required BuildContext dialogContext, required bool isRetryLoading}) = _generalSettings;

  const factory HomeEvent.decreaseQuantityOfProduct({required BuildContext context}) = _decreaseQuantityOfProduct;

  const factory HomeEvent.updateQuantityOfProduct({required BuildContext context, required String quantity}) = _updateQuantityOfProduct;

  const factory HomeEvent.changeNoteOfProduct({required String newNote}) = _changeNoteOfProduct;

  const factory HomeEvent.changeSupplierSelectionExpansionEvent({bool? isSelectSupplier}) = _changeSupplierSelectionExpansionEvent;

  const factory HomeEvent.supplierSelectionEvent({required int supplierIndex, required BuildContext context, required int supplierSaleIndex}) = _supplierSelectionEvent;

  const factory HomeEvent.addToCartProductEvent({
    required BuildContext context,
    required String productId,
  }) = _addToCartProductEvent;

  const factory HomeEvent.setCartCountEvent() = _setCartCountEvent;

  const factory HomeEvent.setMessageCountEvent({required int messageCount}) = _setMessageCountEvent;

  const factory HomeEvent.getWalletRecordEvent({required BuildContext context}) = _getWalletRecordEvent;

  const factory HomeEvent.getOrderCountEvent({
    required BuildContext context,
  }) = _getOrderCountEvent;

  const factory HomeEvent.getMessageListEvent({
    required BuildContext context,
  }) = _getMessageListEvent;

  const factory HomeEvent.getCartCountEvent({
    required BuildContext context,
  }) = _getCartCountEvent;

  const factory HomeEvent.removeOrUpdateMessageEvent({required String messageId, required bool isRead, required bool isDelete}) = _removeOrUpdateMessageEvent;

  const factory HomeEvent.updateImageIndexEvent({
    required int index,
  }) = _updateImageIndexEvent;

  const factory HomeEvent.updateMessageListEvent({
    required List<String> messageIdList,
  }) = _updateMessageListEvent;

  const factory HomeEvent.toggleNoteEvent({
    required bool isBarcode,
  }) = _ToggleNoteEvent;

  const factory HomeEvent.getProfileDetailsEvent({
    required BuildContext context,
  }) = _getProfileDetailsEvent;

  const factory HomeEvent.getRecommendationProductsListEvent({required BuildContext context}) = _getRecommendationProductsListEvent;

  const factory HomeEvent.changeCategoryExpansion({bool? isOpened}) = _changeCategoryExpansion;

  const factory HomeEvent.globalSearchEvent({required BuildContext context}) = _globalSearchEvent;

  const factory HomeEvent.updateGlobalSearchEvent({required String search, required List<SearchModel> searchList}) = _updateGlobalSearchEvent;

  const factory HomeEvent.getProductCategoriesListEvent({required BuildContext context}) = _getProductCategoriesListEvent;

  const factory HomeEvent.checkVersionOfAppEvent({required BuildContext context}) = _checkVersionOfAppEvent;

  const factory HomeEvent.relatedProductsEvent({required BuildContext context, required String productId}) = _relatedProductsEvent;
  const factory HomeEvent.removeRelatedProductEvent() = _removeRelatedProductEvent;

  const factory HomeEvent.getPermissionList({required BuildContext context}) = _getPermissionList;

  const factory HomeEvent.userApproveEvent({required BuildContext context}) = _userApproveEvent;

  const factory HomeEvent.updateMaintenanceEvent({required BuildContext context}) = _updateMaintenanceEvent;
  const factory HomeEvent.callAPIEvent({required BuildContext context}) = _callAPIEvent;

  const factory HomeEvent.updateListQuantityOfProduct({
    required BuildContext context,
    required String quantity,
    required int productListIndex,
    required int productStockUpdateIndex,
    required String productSupplierIds,
  }) = _updateListQuantityOfProductEvent;

  const factory HomeEvent.increaseListQuantityOfProduct({
    required BuildContext context,
    required int productListIndex,
    required int productStockUpdateIndex,
    required String productSupplierIds,
  }) = _increaseListQuantityOfProductEvent;

  const factory HomeEvent.decreaseListQuantityOfProduct({
    required BuildContext context,
    required int productListIndex,
    required int productStockUpdateIndex,
    required String productSupplierIds,
  }) = _decreaseListQuantityOfProductEvent;

  const factory HomeEvent.addToCartListProductEvent({
    required BuildContext context,
    required String productId,
    required int productListIndex,
    required int productStockUpdateIndex,
    required String productSupplierIds,
  }) = _addToCartListProductEvent;

  const factory HomeEvent.syncCartWithProductStockListEvent({
    required BuildContext context,

  }) = _syncCartWithProductStockListEvent;


}
