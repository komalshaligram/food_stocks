part of 'planogram_product_bloc.dart';

@freezed
class PlanogramProductEvent with _$PlanogramProductEvent {
  const factory PlanogramProductEvent.getPlanogramProductsEvent(
      {required PlanogramDatum planogram,required BuildContext context}) = _GetPlanogramProductsEvent;

  const factory PlanogramProductEvent.getProductDetailsEvent(
      {required BuildContext context,
      required String productId,
      required bool isBarcode,
        required int productListIndex
      }) = _GetProductDetailsEvent;

  const factory PlanogramProductEvent.increaseQuantityOfProduct(
      {required BuildContext context}) = _IncreaseQuantityOfProduct;

  const factory PlanogramProductEvent.decreaseQuantityOfProduct(
      {required BuildContext context}) = _DecreaseQuantityOfProduct;

  const factory PlanogramProductEvent.updateQuantityOfProduct(
      {required BuildContext context,
      required String quantity}) = _UpdateQuantityOfProduct;

  const factory PlanogramProductEvent.changeSupplierSelectionExpansionEvent(
      {bool? isSelectSupplier}) = _ChangeSupplierSelectionExpansionEvent;

  const factory PlanogramProductEvent.supplierSelectionEvent(
      {required int supplierIndex,
      required BuildContext context,
      required int supplierSaleIndex}) = _SupplierSelectionEvent;

  const factory PlanogramProductEvent.addToCartProductEvent(
      {required BuildContext context,
      required String productId
      }) = _AddToCartProductEvent;

  const factory PlanogramProductEvent.setCartCountEvent() = _SetCartCountEvent;

  const factory PlanogramProductEvent.updateImageIndexEvent({
    required int index,
  }) = _UpdateImageIndexEvent;


  const factory PlanogramProductEvent.isCategoryEvent(
      {required bool isSubCategory}) = _isCategoryEvent;

  const factory PlanogramProductEvent.getPlanogramByIdEvent({
    required BuildContext context
  }) = _getPlanogramByIdEvent;

  const factory PlanogramProductEvent.getPlanogramAllProductEvent({
    required BuildContext context,
  }) = _getPlanogramAllProductEvent;

  const factory PlanogramProductEvent.getSubCategoryProductEvent({
    required BuildContext context,
  }) = _getSubCategoryProductEvent;

  const factory PlanogramProductEvent.getCartCountEvent(
      ) = _getCartCountEvent;

  const factory PlanogramProductEvent.getGridListView(
      ) = _getGridListView;

  const factory PlanogramProductEvent.changeCategoryExpansion({bool? isOpened}) =
  _ChangeCategoryExpansion;

  const factory PlanogramProductEvent.globalSearchEvent({required BuildContext context}) =
  _GlobalSearchEvent;

  const factory PlanogramProductEvent.updateGlobalSearchEvent(
      {required String search,
        required List<SearchModel> searchList}) = _UpdateGlobalSearchEvent;

  const factory PlanogramProductEvent.getProductCategoriesListEvent(
      {required BuildContext context}) = _GetProductCategoriesListEvent;

  const factory PlanogramProductEvent.RelatedProductsEvent({required BuildContext context,required String productId}) = _RelatedProductsEvent;
  const factory PlanogramProductEvent.RemoveRelatedProductEvent() = _RemoveRelatedProductEvent;

}
