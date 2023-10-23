part of 'supplier_products_bloc.dart';

@freezed
class SupplierProductsEvent with _$SupplierProductsEvent {
  const factory SupplierProductsEvent.getSupplierProductsListEvent() =
      _GetSupplierProductsListEvent;
}
