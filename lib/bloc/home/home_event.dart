part of 'home_bloc.dart';

@freezed
class HomeEvent with _$HomeEvent {
  const factory HomeEvent.getPreferencesDataEvent() = _getPreferencesDataEvent;

  const factory HomeEvent.getProductSalesListEvent(
      {required BuildContext context}) = _GetProductSalesListEvent;

  const factory HomeEvent.getProductDetailsEvent(
      {required BuildContext context,
        required bool isBarcode,
      required String productId}) = _GetProductDetailsEvent;

  const factory HomeEvent.increaseQuantityOfProduct(
      {required BuildContext context}) = _IncreaseQuantityOfProduct;

  const factory HomeEvent.decreaseQuantityOfProduct(
      {required BuildContext context}) = _DecreaseQuantityOfProduct;

  const factory HomeEvent.updateQuantityOfProduct(
      {required BuildContext context,
      required String quantity}) = _UpdateQuantityOfProduct;

  const factory HomeEvent.changeNoteOfProduct({required String newNote}) =
      _ChangeNoteOfProduct;

  const factory HomeEvent.changeSupplierSelectionExpansionEvent(
      {bool? isSelectSupplier}) = _ChangeSupplierSelectionExpansionEvent;

  const factory HomeEvent.supplierSelectionEvent(
      {required int supplierIndex,
      required BuildContext context,
      required int supplierSaleIndex}) = _SupplierSelectionEvent;

  const factory HomeEvent.addToCartProductEvent(
      {required BuildContext context,
      required String productId
      }) = _AddToCartProductEvent;

  const factory HomeEvent.setCartCountEvent() = _SetCartCountEvent;

  const factory HomeEvent.setMessageCountEvent({required int messageCount}) =
      _SetMessageCountEvent;

  const factory HomeEvent.getWalletRecordEvent(
      {required BuildContext context}) = _getWalletRecordEvent;

  const factory HomeEvent.getOrderCountEvent({
    required BuildContext context,
  }) = _getOrderCountEvent;

  const factory HomeEvent.getMessageListEvent({
    required BuildContext context,
  }) = _GetMessageListEvent;

  const factory HomeEvent.getCartCountEvent({
    required BuildContext context,
  }) = _GetCartCountEvent;

  const factory HomeEvent.removeOrUpdateMessageEvent(
      {required String messageId,
      required bool isRead,
      required bool isDelete}) = _RemoveOrUpdateMessageEvent;

  const factory HomeEvent.updateImageIndexEvent({
    required int index,
  }) = _UpdateImageIndexEvent;

  const factory HomeEvent.updateMessageListEvent({
    required List<String> messageIdList,
  }) = _UpdateMessageListEvent;

  const factory HomeEvent.toggleNoteEvent({
    required bool isBarcode,
}) = _ToggleNoteEvent;

  const factory HomeEvent.getProfileDetailsEvent({
    required BuildContext context,
}) = _getProfileDetailsEvent;

  const factory HomeEvent.getRecommendationProductsListEvent(
      {required BuildContext context}) = _GetRecommendationProductsListEvent;

  const factory HomeEvent.changeCategoryExpansion({bool? isOpened}) =
  _ChangeCategoryExpansion;

  const factory HomeEvent.globalSearchEvent({required BuildContext context}) =
  _GlobalSearchEvent;

  const factory HomeEvent.updateGlobalSearchEvent(
      {required String search,
        required List<SearchModel> searchList}) = _UpdateGlobalSearchEvent;

  const factory HomeEvent.getProductCategoriesListEvent(
      {required BuildContext context}) = _GetProductCategoriesListEvent;

  const factory HomeEvent.checkVersionOfAppEvent(
      {required BuildContext context}) = _checkVersionOfAppEvent;


  const factory HomeEvent.RelatedProductsEvent({required BuildContext context,required String productId}) = _RelatedProductsEvent;

}
