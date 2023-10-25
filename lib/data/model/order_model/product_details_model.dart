
class ProductDetailsModel{

   String? productName ;
   String? productImage;
   int? productWeight;
   int? productPrice;
   bool isProductIssue;
   bool isDelete;

  ProductDetailsModel({
    this.isProductIssue = false,
    required this.productImage,
    required this.productName,
    required this.productPrice,
    required this.productWeight,
    this.isDelete = false,
  });


}
