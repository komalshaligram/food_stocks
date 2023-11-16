part of 'store_bloc.dart';

@freezed
class StoreState with _$StoreState {
  const factory StoreState({
    required bool isCategoryExpand,
    required List<Category> productCategoryList,
    required ProductSalesResModel productSalesList,
    required SuppliersResModel suppliersList,
    required List<Brand> companiesList,
    required List<SearchModel> searchList,
    required bool isShimmering,
    required bool isLoading,
    required bool isProductLoading,
    required List<Product> productDetails,
    required List<ProductStockModel> productStockList,
    required ProductStockModel scanProductStockDetails,
    required int productStockUpdateIndex,
    required bool isSelectSupplier,
    required List<ProductSupplierModel> productSupplierList,
  }) = _StoreState;

  factory StoreState.initial() => const StoreState(
    isCategoryExpand: false,
        productCategoryList: [],
        productSalesList: ProductSalesResModel(),
        suppliersList: SuppliersResModel(),
        companiesList: [],
        searchList: [],
        isShimmering: false,
        isLoading: false,
        isProductLoading: false,
        productDetails: [],
        productStockUpdateIndex: -1,
        productStockList: [],
        scanProductStockDetails: ProductStockModel(productId: ''),
        isSelectSupplier: false,
        productSupplierList: [],
      );
}
