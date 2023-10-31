part of 'store_bloc.dart';

@freezed
class StoreState with _$StoreState {
  const factory StoreState({
    required bool isCategoryExpand,
    required List<Category> productCategoryList,
    required ProductSalesResModel productSalesList,
    required SuppliersResModel suppliersList,
    required bool isShimmering,
    required bool isLoading,
    required bool isProductLoading,
    required ProductDetailsResModel productDetails,
    required List<ProductStockModel> productStockList,
    required int productStockUpdateIndex,
  }) = _StoreState;

  factory StoreState.initial() => const StoreState(
      isCategoryExpand: false,
      productCategoryList: [],
      productSalesList: ProductSalesResModel(),
      suppliersList: SuppliersResModel(),
      isShimmering: false,
      isLoading: false,
      isProductLoading: false,
      productDetails: ProductDetailsResModel(),
      productStockUpdateIndex: -1,
      productStockList: []);
}
