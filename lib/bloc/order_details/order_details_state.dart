part of 'order_details_bloc.dart';



@freezed
class OrderDetailsState with _$OrderDetailsState {
  const factory OrderDetailsState({
    required List<SupplierDetailsModel>supplierList,
  }) = _OrderDetailsState;

  factory OrderDetailsState.initial() => OrderDetailsState(
      supplierList: [
   SupplierDetailsModel(
       orderStatus: 'Pending delivery',
       deliveryDate: '12.02.23 10:00-12:00',
       productQuantity: 23,
       totalPrice: '18,360₪',
       supplierName: 'Supplier name'
   ),
        SupplierDetailsModel(
            orderStatus: 'Received all',
            deliveryDate: '12.02.23 10:00-12:00',
            productQuantity: 23,
            totalPrice: '18,360₪',
            supplierName: 'Supplier name'
        ),
        SupplierDetailsModel(
            orderStatus: 'Received all',
            deliveryDate: '12.02.23 10:00-12:00',
            productQuantity: 23,
            totalPrice: '18,360₪',
            supplierName: 'Supplier name'
        ),
        SupplierDetailsModel(
            orderStatus: 'Received all',
            deliveryDate: '12.02.23 10:00-12:00',
            productQuantity: 23,
            totalPrice: '18,360₪',
            supplierName: 'Supplier name'
        ),
        SupplierDetailsModel(
            orderStatus: 'Received all',
            deliveryDate: '12.02.23 10:00-12:00',
            productQuantity: 23,
            totalPrice: '18,360₪',
            supplierName: 'Supplier name'
        ),
        SupplierDetailsModel(
            orderStatus: 'Received all',
            deliveryDate: '12.02.23 10:00-12:00',
            productQuantity: 23,
            totalPrice: '18,360₪',
            supplierName: 'Supplier name'
        ),
        SupplierDetailsModel(
            orderStatus: 'Received all',
            deliveryDate: '12.02.23 10:00-12:00',
            productQuantity: 23,
            totalPrice: '18,360₪',
            supplierName: 'Supplier name'
        ),
        SupplierDetailsModel(
            orderStatus: 'Received all',
            deliveryDate: '12.02.23 10:00-12:00',
            productQuantity: 23,
            totalPrice: '18,360₪',
            supplierName: 'Supplier name'
        ),
        SupplierDetailsModel(
            orderStatus: 'Received all',
            deliveryDate: '12.02.23 10:00-12:00',
            productQuantity: 23,
            totalPrice: '18,360₪',
            supplierName: 'Supplier name'
        ),
      ]
  );


}
