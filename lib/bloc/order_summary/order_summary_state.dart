part of 'order_summary_bloc.dart';

@freezed
class OrderSummaryState with _$OrderSummaryState {
  const factory OrderSummaryState({

    required CartProductsSupplierResModel orderSummaryList,
  required bool isEnable,
}) = _OrderSummaryState;

  factory OrderSummaryState.initial() => OrderSummaryState(
 orderSummaryList: CartProductsSupplierResModel(),
    isEnable: false,
  );
}
