part of 'planogram_product_bloc.dart';

@freezed
class PlanogramProductState with _$PlanogramProductState {
  const factory PlanogramProductState({
    required String planogramName,
    required List<Planogramproduct> planogramProductList,
    required bool isLoading,
    required bool isProductLoading,
    required ProductDetailsResModel productDetails,
    required List<ProductStockModel> productStockList,
    required int productStockUpdateIndex,
    required bool isSelectSupplier,
    required List<ProductSupplierModel> productSupplierList,
  }) = _PlanogramProductState;

  factory PlanogramProductState.initial() => PlanogramProductState(
    planogramName: '',
        planogramProductList: [],
        isLoading: false,
        isProductLoading: false,
        productDetails: ProductDetailsResModel(),
        productStockUpdateIndex: -1,
        productStockList: [],
        isSelectSupplier: false,
        productSupplierList: [],
      );
}
