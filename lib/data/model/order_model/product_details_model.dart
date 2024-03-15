
class ProductDetailsModel{

   String? productName ;
   String? mainImage;
   int? totalQuantity;
   double? totalPayment;
   bool isProductIssue;
   bool isDelete;
  String cartProductId;
  String scales;
  double weight;
  bool? isProcess;
 String? lowStock;
 double? productStock;



  ProductDetailsModel({
    this.isProductIssue = false,
    required this.mainImage,
    required this.productName,
    required this.totalPayment,
    required this.totalQuantity,
    this.isDelete = false,
     this.cartProductId = '',
    required this.scales,
    required this.weight,
     this.isProcess = false,
    this.lowStock = '',
    this.productStock = 0

   //required this.discountPercentage,
  });


}
