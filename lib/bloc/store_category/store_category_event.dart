part of 'store_category_bloc.dart';

@freezed
class StoreCategoryEvent with _$StoreCategoryEvent {
  const factory StoreCategoryEvent.changeCategoryExpansionEvent(
      {bool? isOpened}) = _ChangeCategoryExpansionEvent;

  const factory StoreCategoryEvent.changeCategoryOrSubCategoryEvent(
      {required bool isCategory,
      required BuildContext context}) = _ChangeCategoryOrSubCategoryEvent;

  const factory StoreCategoryEvent.getPlanogramProductsEvent(
      {required BuildContext context}) = _GetPlanogramProductsEvent;

  const factory StoreCategoryEvent.getProductDetailsEvent(
      {required BuildContext context,
      required String productId}) = _GetProductDetailsEvent;

  const factory StoreCategoryEvent.increaseQuantityOfProduct(
      {required BuildContext context}) = _IncreaseQuantityOfProduct;

  const factory StoreCategoryEvent.decreaseQuantityOfProduct(
      {required BuildContext context}) = _DecreaseQuantityOfProduct;

  const factory StoreCategoryEvent.changeNoteOfProduct(
      {required String newNote}) = _ChangeNoteOfProduct;

  const factory StoreCategoryEvent.verifyProductStockEvent(
      {required BuildContext context}) = _VerifyProductStockEvent;
}
