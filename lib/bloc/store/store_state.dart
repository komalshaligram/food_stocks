part of 'store_bloc.dart';

@freezed
class StoreState with _$StoreState {
  const factory StoreState({
    required bool isCategoryExpand,
    required List<CategoryModel.Category> productCategoryList,
    required List<SalesModel.Datum> productSalesList,
    required List<SuppliersModel.Datum> suppliersList,
    required bool isShimmering,
  }) = _StoreState;

  factory StoreState.initial() => const StoreState(
    isCategoryExpand: false,
        productCategoryList: [],
        productSalesList: [],
        suppliersList: [],
        isShimmering: false,
      );
}
