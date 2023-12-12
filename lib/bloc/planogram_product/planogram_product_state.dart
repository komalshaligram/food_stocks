part of 'planogram_product_bloc.dart';

@freezed
class PlanogramProductState with _$PlanogramProductState {
  const factory PlanogramProductState({
    required String planogramName,
    required List<Planogramproduct> planogramProductList,
    required bool isLoading,
    required bool isProductLoading,
    required List<Product> productDetails,
    required List<ProductStockModel> productStockList,
    required int productStockUpdateIndex,
    required bool isSelectSupplier,
    required List<ProductSupplierModel> productSupplierList,
    required bool isCartCountChange,
    required int imageIndex,
    required TextEditingController noteController,
  }) = _PlanogramProductState;

  factory PlanogramProductState.initial() => PlanogramProductState(
    planogramName: '',
        planogramProductList: [],
        isLoading: false,
        isProductLoading: false,
        productDetails: [],
        productStockUpdateIndex: -1,
        productStockList: [],
        isSelectSupplier: false,
        productSupplierList: [],
        isCartCountChange: false,
        imageIndex: 0,
        noteController: TextEditingController(),
      );
}
