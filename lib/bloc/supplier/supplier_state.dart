part of 'supplier_bloc.dart';

@freezed
class SupplierState with _$SupplierState {
  const factory SupplierState({
    required List<Datum> suppliersList,
    required bool isShimmering,
    required int pageNum,
    required bool isLoadMore,
    required bool isBottomOfSuppliers,
  }) = _SupplierState;

  factory SupplierState.initial() => const SupplierState(
    suppliersList: [],
        isShimmering: false,
        pageNum: 0,
        isLoadMore: false,
        isBottomOfSuppliers: false,
      );
}
