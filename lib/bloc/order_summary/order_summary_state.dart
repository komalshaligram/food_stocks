part of 'order_summary_bloc.dart';

@freezed
class OrderSummaryState with _$OrderSummaryState {
  const factory OrderSummaryState({

    required CartProductsSupplierResModel orderSummaryList,
    required bool isLoading,
    required bool isShimmering,
    required bool isEnable,

}) = _OrderSummaryState;

  factory OrderSummaryState.initial() => OrderSummaryState(
 orderSummaryList: CartProductsSupplierResModel(),
    isLoading: false,
    isShimmering: false,
    isEnable: false
  );
}
