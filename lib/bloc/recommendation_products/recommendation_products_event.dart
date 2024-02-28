part of 'recommendation_products_bloc.dart';

@freezed
class RecommendationProductsEvent with _$RecommendationProductsEvent {
  const factory RecommendationProductsEvent.getRecommendationProductsEvent(
      {required BuildContext context}) = _GetRecommendationProductsEvent;

  const factory RecommendationProductsEvent.getProductDetailsEvent(
      {required BuildContext context,
      required String productId,
        required bool isBarcode
      }) = _GetProductDetailsEvent;

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
      {required BuildContext context,
        required String productId
      }) = _AddToCartProductEvent;

  const factory RecommendationProductsEvent.setCartCountEvent() =
      _SetCartCountEvent;

  const factory RecommendationProductsEvent.updateImageIndexEvent({
    required int index,
  }) = _UpdateImageIndexEvent;

  const factory RecommendationProductsEvent.toggleNoteEvent() =
      _ToggleNoteEvent;

  const factory RecommendationProductsEvent.refreshListEvent(
      {required BuildContext context}) = _RefreshListEvent;
  const factory RecommendationProductsEvent.getCartCountEvent(
      ) = _getCartCountEvent;

  const factory RecommendationProductsEvent.getGridListView(
      ) = _getGridListView;

  const factory RecommendationProductsEvent.changeCategoryExpansion({bool? isOpened}) =
  _ChangeCategoryExpansion;

  const factory RecommendationProductsEvent.globalSearchEvent({required BuildContext context}) =
  _GlobalSearchEvent;

  const factory RecommendationProductsEvent.updateGlobalSearchEvent(
      {required String search,
        required List<SearchModel> searchList}) = _UpdateGlobalSearchEvent;

  const factory RecommendationProductsEvent.getProductCategoriesListEvent(
      {required BuildContext context}) = _GetProductCategoriesListEvent;

  const factory RecommendationProductsEvent.RelatedProductsEvent({required BuildContext context,required String productId}) = _RelatedProductsEvent;
  const factory RecommendationProductsEvent.RemoveRelatedProductEvent() = _RemoveRelatedProductEvent;

}
