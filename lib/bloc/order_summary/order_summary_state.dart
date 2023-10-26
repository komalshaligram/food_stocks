part of 'order_summary_bloc.dart';

@freezed
class OrderSummaryState with _$OrderSummaryState {
  const factory OrderSummaryState({
    required List<SupplierDetailsModel>orderSummaryList,
    required bool isShimmering,
}) = _OrderSummaryState;

  factory OrderSummaryState.initial() => OrderSummaryState(
    isShimmering: false,
      orderSummaryList: [
        SupplierDetailsModel(
            deliveryDate: '12.02.23 10:00-12:00',
            productQuantity: 23,
            totalPrice: '18,360₪',
            supplierName: 'Supplier name'
        ),
        SupplierDetailsModel(
            deliveryDate: '12.02.23 10:00-12:00',
            productQuantity: 23,
            totalPrice: '18,360₪',
            supplierName: 'Supplier name'
        ),
        SupplierDetailsModel(
            deliveryDate: '12.02.23 10:00-12:00',
            productQuantity: 23,
            totalPrice: '18,360₪',
            supplierName: 'Supplier name'
        ),
        SupplierDetailsModel(
            deliveryDate: '12.02.23 10:00-12:00',
            productQuantity: 23,
            totalPrice: '18,360₪',
            supplierName: 'Supplier name'
        ),



      ]
  );
}
