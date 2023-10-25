
class SupplierDetailsModel{

  String? supplierName ;
  String? orderStatus;
 String? deliveryDate;
 int? productQuantity;
 String? totalPrice;

  SupplierDetailsModel({
   this.orderStatus  = '',
    required this.deliveryDate,
    required this.productQuantity,
    required this.totalPrice,
    required this.supplierName
  });


}
