part of 'supplier_bloc.dart';

@freezed
class SupplierState with _$SupplierState {
  const factory SupplierState({
    required List<Datum> suppliersList,
  }) = _SupplierState;

  factory SupplierState.initial() => const SupplierState(
        suppliersList: [],
      );
}
