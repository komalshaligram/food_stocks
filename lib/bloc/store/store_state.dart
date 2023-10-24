part of 'store_bloc.dart';

@freezed
class StoreState with _$StoreState {
  const factory StoreState({
    required bool isCategoryExpand,
    required bool isMirror,
    required List<Category> productCategoryList,
    required List<Sale> productSalesList,
    required List<Datum> suppliersList,
    required bool isShimmering,
  }) = _StoreState;

  factory StoreState.initial() => const StoreState(
    isCategoryExpand: false,
        isMirror: false,
        productCategoryList: [],
        productSalesList: [],
        suppliersList: [],
        isShimmering: false,
      );
}
