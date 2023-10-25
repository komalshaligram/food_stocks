
class OrderDetailsModel{

  String? orderNumber ;
  String? orderStatus;
  int? noOfSupplier;
 String?  orderDate;
  int? productQuantity;
String? totalPrice;

  OrderDetailsModel({
required this.orderDate,
    required this.noOfSupplier,
    required this.orderNumber,
    required this.orderStatus,
    required this.productQuantity,
    required this.totalPrice
  });
}
