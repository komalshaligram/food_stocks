part of 'product_sale_bloc.dart';

@freezed
class ProductSaleState with _$ProductSaleState {
  const factory ProductSaleState({
    required ProductSalesResModel productSalesList,
    required bool isShimmering,
  }) = _ProductSaleState;

  factory ProductSaleState.initial() => const ProductSaleState(
        productSalesList: ProductSalesResModel(),
        isShimmering: false,
      );
}
