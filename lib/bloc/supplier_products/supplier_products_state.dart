part of 'supplier_products_bloc.dart';

@freezed
class SupplierProductsState with _$SupplierProductsState {
  const factory SupplierProductsState({required List<Datum> productList}) =
      _SupplierProductsState;

  factory SupplierProductsState.initial() =>
      SupplierProductsState(productList: []);
}
