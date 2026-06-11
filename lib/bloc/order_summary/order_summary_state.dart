part of 'order_summary_bloc.dart';

@freezed
class OrderSummaryState with _$OrderSummaryState {
  const factory OrderSummaryState({
    required CartProductsSupplierResModel orderSummaryList,
    required GetAllCartResModel cartItemList,
    required String language,
    required List<CartProductDataResModel> tempList,
    required String total,
    String? backString,
    String? firstSupplierOrderMessageTemplate,
  }) = _OrderSummaryState;

  factory OrderSummaryState.initial() => const OrderSummaryState(
        orderSummaryList: CartProductsSupplierResModel(),
        cartItemList: GetAllCartResModel(),
        language: '',
        tempList: [],
        total: '',
        backString: '',
        firstSupplierOrderMessageTemplate: '',
      );
}
