part of 'store_bloc.dart';

@freezed
class StoreEvent with _$StoreEvent {
  const factory StoreEvent.changeCategoryExpansion({bool? isOpened}) =
      _ChangeCategoryExpansion;

  const factory StoreEvent.getProductCategoriesListEvent(
      {required BuildContext context}) = _GetProductCategoriesListEvent;

  const factory StoreEvent.getProductSalesListEvent(
      {required BuildContext context}) = _GetProductSalesListEvent;

  const factory StoreEvent.getSuppliersListEvent(
      {required BuildContext context}) = _GetSuppliersListEvent;

  const factory StoreEvent.getProductDetailsEvent(
      {required BuildContext context,
      required String productId}) = _GetProductDetailsEvent;

  const factory StoreEvent.increaseQuantityOfProduct(
      {required BuildContext context}) = _IncreaseQuantityOfProduct;

  const factory StoreEvent.decreaseQuantityOfProduct(
      {required BuildContext context}) = _DecreaseQuantityOfProduct;

  const factory StoreEvent.changeNoteOfProduct({required String newNote}) =
      _ChangeNoteOfProduct;

  const factory StoreEvent.verifyProductStockEvent(
      {required BuildContext context}) = _VerifyProductStockEvent;

  const factory StoreEvent.getScanProductDetailsEvent(
      {required String scanResult}) = _GetScanProductDetailsEvent;
}
