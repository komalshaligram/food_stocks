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
}
