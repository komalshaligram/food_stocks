part of 'order_bloc.dart';

@freezed
class OrderState with _$OrderState {
  const factory OrderState({
   required List<OrderDetailsModel>orderList1,
   required GetAllOrderResModel orderList,
  }) = _OrderState;

   factory OrderState.initial() => OrderState(
       orderList: GetAllOrderResModel(),
  orderList1: [
   OrderDetailsModel(
       orderDate: '12.05.2023',
       noOfSupplier: 3,
       orderNumber: '1250123',
       orderStatus: 'Pending delivery',
       productQuantity: 23,
       totalPrice: '12,450₪'
   ),
    OrderDetailsModel(
        orderDate: '12.05.2023',
        noOfSupplier: 3,
        orderNumber: '1250123',
        orderStatus: 'Received all',
        productQuantity: 23,
        totalPrice: '12,450₪'
    ),
    OrderDetailsModel(
        orderDate: '12.05.2023',
        noOfSupplier: 3,
        orderNumber: '1250123',
        orderStatus: 'Received all',
        productQuantity: 23,
        totalPrice: '12,450₪'
    ),
    OrderDetailsModel(
        orderDate: '12.05.2023',
        noOfSupplier: 3,
        orderNumber: '1250123',
        orderStatus: 'Received all',
        productQuantity: 23,
        totalPrice: '12,450₪'
    ),
    OrderDetailsModel(
        orderDate: '12.05.2023',
        noOfSupplier: 3,
        orderNumber: '1250123',
        orderStatus: 'Received all',
        productQuantity: 23,
        totalPrice: '12,450₪'
    ),   OrderDetailsModel(
       orderDate: '12.05.2023',
        noOfSupplier: 3,
        orderNumber: '1250123',
        orderStatus: 'Pending delivery',
        productQuantity: 23,
        totalPrice: '12,450₪'
    ),
    OrderDetailsModel(
        orderDate: '12.05.2023',
        noOfSupplier: 3,
        orderNumber: '1250123',
        orderStatus: 'Received all',
        productQuantity: 23,
        totalPrice: '12,450₪'
    ),
    OrderDetailsModel(
        orderDate: '12.05.2023',
        noOfSupplier: 3,
        orderNumber: '1250123',
        orderStatus: 'Received all',
        productQuantity: 23,
        totalPrice: '12,450₪'
    ),

  ]
  );


}
