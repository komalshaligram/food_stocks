part of 'supplier_bloc.dart';

@freezed
class SupplierState with _$SupplierState {
  const factory SupplierState({
    required List<SupplierListData> suppliersDataList,
    required String search,
    required bool isShimmering,
    required int pageNum,
    required bool isLoadMore,
    required bool isBottomOfSuppliers,
    required RefreshController refreshController,
  }) = _SupplierState;

  factory SupplierState.initial() => SupplierState(
        suppliersDataList: [],
        search: '',
        isShimmering: false,
        pageNum: 0,
        isLoadMore: false,
        isBottomOfSuppliers: false,
        refreshController: RefreshController(),
      );
}
