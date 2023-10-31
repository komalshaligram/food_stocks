part of 'product_sale_bloc.dart';

@freezed
class ProductSaleState with _$ProductSaleState {
  const factory ProductSaleState({
    required ProductSalesResModel productSalesList,
    required ProductDetailsResModel productDetails,
    required List<ProductStockModel> productStockList,
    required bool isShimmering,
    required bool isLoading,
    required bool isProductLoading,
    required int productStockUpdateIndex,
  }) = _ProductSaleState;

  factory ProductSaleState.initial() => const ProductSaleState(
      productSalesList: ProductSalesResModel(),
      productDetails: ProductDetailsResModel(),
      isShimmering: false,
      isLoading: false,
      isProductLoading: false,
      productStockUpdateIndex: -1,
      productStockList: []);
}
