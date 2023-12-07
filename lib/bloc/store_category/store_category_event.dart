part of 'store_category_bloc.dart';

@freezed
class StoreCategoryEvent with _$StoreCategoryEvent {
  const factory StoreCategoryEvent.changeCategoryExpansionEvent(
      {bool? isOpened}) = _ChangeCategoryExpansionEvent;

  const factory StoreCategoryEvent.changeCategoryDetailsEvent(
      {required String categoryId,
      required String categoryName,
      required BuildContext context}) = _ChangeCategoryDetailsEvent;

  const factory StoreCategoryEvent.changeSubCategoryDetailsEvent(
      {required String subCategoryId,
      required String subCategoryName,
      required BuildContext context}) = _ChangeSubCategoryDetailsEvent;

  const factory StoreCategoryEvent.getSubCategoryListEvent(
      {required BuildContext context}) = _GetSubCategoryListEvent;

  const factory StoreCategoryEvent.changeSubCategoryOrPlanogramEvent(
      {required bool isSubCategory,
      required BuildContext context}) = _ChangeSubCategoryOrPlanogramEvent;

  const factory StoreCategoryEvent.getPlanoGramProductsEvent(
      {required BuildContext context}) = _GetPlanoGramProductsEvent;

  const factory StoreCategoryEvent.getProductDetailsEvent(
      {required BuildContext context,
      required String productId,
      required int planoGramIndex,
      bool? isBarcode}) = _GetProductDetailsEvent;

  const factory StoreCategoryEvent.increaseQuantityOfProduct(
      {required BuildContext context}) = _IncreaseQuantityOfProduct;

  const factory StoreCategoryEvent.decreaseQuantityOfProduct(
      {required BuildContext context}) = _DecreaseQuantityOfProduct;

  const factory StoreCategoryEvent.changeNoteOfProduct(
      {required String newNote}) = _ChangeNoteOfProduct;

  const factory StoreCategoryEvent.changeSupplierSelectionExpansionEvent(
      {bool? isSelectSupplier}) = _ChangeSupplierSelectionExpansionEvent;

  const factory StoreCategoryEvent.supplierSelectionEvent(
      {required int supplierIndex,
      required BuildContext context,
      required int supplierSaleIndex}) = _SupplierSelectionEvent;

  const factory StoreCategoryEvent.addToCartProductEvent(
      {required BuildContext context}) = _AddToCartProductEvent;

  const factory StoreCategoryEvent.setCartCountEvent() = _SetCartCountEvent;

  const factory StoreCategoryEvent.globalSearchEvent({required String search,
    required BuildContext context}) = _GlobalSearchEvent;

  const factory StoreCategoryEvent.updateImageIndexEvent({
    required int index,
  }) = _UpdateImageIndexEvent;

  const factory StoreCategoryEvent.updateGlobalSearchEvent(
      {required String search,
        required List<SearchModel> searchList}) = _UpdateGlobalSearchEvent;

  const factory StoreCategoryEvent.toggleNoteEvent() = _ToggleNoteEvent;
}
