
class ProductDetailsModel{

   String? productName ;
   String? categoryImage;
   int? itemWeight;
   int? totalPayment;
   bool isProductIssue;
   bool isDelete;

  ProductDetailsModel({
    this.isProductIssue = false,
    required this.categoryImage,
    required this.productName,
    required this.totalPayment,
    required this.itemWeight,
    this.isDelete = false,
  });


}
