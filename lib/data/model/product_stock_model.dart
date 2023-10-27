class ProductStockModel {
  String productId;
  List<String> productSupplierIds;
  int quantity;

  ProductStockModel({
    required this.productId,
    this.productSupplierIds = const [],
    this.quantity = 0,
  });
}
