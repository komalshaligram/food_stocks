part of 'supplier_bloc.dart';

@freezed
class SupplierState with _$SupplierState {
  const factory SupplierState({
    required List<Datum> suppliersList,
    required String search,
    required bool isShimmering,
    required int pageNum,
    required bool isLoadMore,
    required bool isBottomOfSuppliers,
    required RefreshController refreshController,
  }) = _SupplierState;

  factory SupplierState.initial() => SupplierState(
        suppliersList: [],
        search: '',
        isShimmering: false,
        pageNum: 0,
        isLoadMore: false,
        isBottomOfSuppliers: false,
        refreshController: RefreshController(),
      );
}
