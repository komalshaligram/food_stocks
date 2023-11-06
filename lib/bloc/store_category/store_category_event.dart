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
      required int planoGramIndex}) = _GetProductDetailsEvent;

  const factory StoreCategoryEvent.increaseQuantityOfProduct(
      {required BuildContext context}) = _IncreaseQuantityOfProduct;

  const factory StoreCategoryEvent.decreaseQuantityOfProduct(
      {required BuildContext context}) = _DecreaseQuantityOfProduct;

  const factory StoreCategoryEvent.changeNoteOfProduct(
      {required String newNote}) = _ChangeNoteOfProduct;

  const factory StoreCategoryEvent.verifyProductStockEvent(
      {required BuildContext context}) = _VerifyProductStockEvent;
}
