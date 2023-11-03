part of 'planogram_product_bloc.dart';

@freezed
class PlanogramProductEvent with _$PlanogramProductEvent {
  const factory PlanogramProductEvent.getPlanogramProductsEvent(
      {required Datum planogram}) = _GetPlanogramProductsEvent;

  const factory PlanogramProductEvent.getProductDetailsEvent(
      {required BuildContext context,
      required String productId}) = _GetProductDetailsEvent;

  const factory PlanogramProductEvent.increaseQuantityOfProduct(
      {required BuildContext context}) = _IncreaseQuantityOfProduct;

  const factory PlanogramProductEvent.decreaseQuantityOfProduct(
      {required BuildContext context}) = _DecreaseQuantityOfProduct;

  const factory PlanogramProductEvent.changeNoteOfProduct(
      {required String newNote}) = _ChangeNoteOfProduct;

  const factory PlanogramProductEvent.addProductToBasketEvent(
      {required BuildContext context}) = _AddProductToBasketEvent;
}
