part of 'order_summary_bloc.dart';

@freezed
class OrderSummaryState with _$OrderSummaryState {
  const factory OrderSummaryState({
    required CartProductsSupplierResModel orderSummaryList,
    required GetAllCartResModel cartItemList,
    required String language,
    required List<CartProductDataResModel> tempList,
    required String total,
    required Map<String, SupplierCityDeliveryScheduleData> deliverySchedules,
    required bool isDeliveryScheduleLoading,
    String? backString,
    String? firstSupplierOrderMessageTemplate,
  }) = _OrderSummaryState;

  factory OrderSummaryState.initial() => const OrderSummaryState(
    orderSummaryList: CartProductsSupplierResModel(),
    cartItemList: GetAllCartResModel(),
    language: '',
    tempList: [],
    total: '',
    deliverySchedules: {},
    isDeliveryScheduleLoading: false,
    backString: '',
    firstSupplierOrderMessageTemplate: '',
  );
}