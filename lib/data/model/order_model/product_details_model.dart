
class ProductDetailsModel{

   String? productName ;
   String? mainImage;
   int? totalQuantity;
   int? totalPayment;
   bool isProductIssue;
   bool isDelete;
  String cartProductId;


  ProductDetailsModel({
    this.isProductIssue = false,
    required this.mainImage,
    required this.productName,
    required this.totalPayment,
    required this.totalQuantity,
    this.isDelete = false,
     this.cartProductId = '',

  });


}
