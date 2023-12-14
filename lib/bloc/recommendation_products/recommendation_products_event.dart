part of 'recommendation_products_bloc.dart';

@freezed
class RecommendationProductsEvent with _$RecommendationProductsEvent {
  const factory RecommendationProductsEvent.getRecommendationProductsEvent(
      {required BuildContext context}) = _GetRecommendationProductsEvent;

  const factory RecommendationProductsEvent.getProductDetailsEvent(
      {required BuildContext context,
      required String productId}) = _GetProductDetailsEvent;

  const factory RecommendationProductsEvent.increaseQuantityOfProduct(
      {required BuildContext context}) = _IncreaseQuantityOfProduct;

  const factory RecommendationProductsEvent.decreaseQuantityOfProduct(
      {required BuildContext context}) = _DecreaseQuantityOfProduct;

  const factory RecommendationProductsEvent.updateQuantityOfProduct(
      {required BuildContext context,
      required String quantity}) = _UpdateQuantityOfProduct;

  const factory RecommendationProductsEvent.changeNoteOfProduct(
      {required String newNote}) = _ChangeNoteOfProduct;

  const factory RecommendationProductsEvent.changeSupplierSelectionExpansionEvent(
      {bool? isSelectSupplier}) = _ChangeSupplierSelectionExpansionEvent;

  const factory RecommendationProductsEvent.supplierSelectionEvent(
      {required int supplierIndex,
      required BuildContext context,
      required int supplierSaleIndex}) = _SupplierSelectionEvent;

  const factory RecommendationProductsEvent.addToCartProductEvent(
      {required BuildContext context}) = _AddToCartProductEvent;

  const factory RecommendationProductsEvent.setCartCountEvent() =
      _SetCartCountEvent;

  const factory RecommendationProductsEvent.updateImageIndexEvent({
    required int index,
  }) = _UpdateImageIndexEvent;

  const factory RecommendationProductsEvent.toggleNoteEvent() =
      _ToggleNoteEvent;

  const factory RecommendationProductsEvent.refreshListEvent(
      {required BuildContext context}) = _RefreshListEvent;
}
