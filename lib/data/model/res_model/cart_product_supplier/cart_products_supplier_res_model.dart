import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_products_supplier_res_model.freezed.dart';
part 'cart_products_supplier_res_model.g.dart';

@freezed
class CartProductsSupplierResModel with _$CartProductsSupplierResModel {
  const factory CartProductsSupplierResModel({
    @JsonKey(name: "status") int? status,
    @JsonKey(name: "data") Data? data,
    @JsonKey(name: "message") String? message,
  }) = _CartProductsSupplierResModel;

  factory CartProductsSupplierResModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$CartProductsSupplierResModelFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
    @JsonKey(name: "cart") List<Cart>? cart,
    @JsonKey(name: "data") List<CartProductDataResModel>? data,
    @JsonKey(name: "openRefundTotalAmount", fromJson: _toDoubleNullable)
    double? openRefundTotalAmount,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
class Cart with _$Cart {
  const factory Cart({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "clientId") String? clientId,
    @JsonKey(name: "totalAmount", fromJson: _toDoubleNullable) double? totalAmount,
  }) = _Cart;

  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);
}

@freezed
class CartProductDataResModel with _$CartProductDataResModel {
  const factory CartProductDataResModel({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "draftReturnExists") bool? draftReturnExists,
    @JsonKey(name: "suppliers") Suppliers? suppliers,
    @JsonKey(name: "sales") Sales? sales,
    @JsonKey(name: "productDetails") List<ProductDetail>? productDetails,
    @JsonKey(name: "totalQuantity", fromJson: _toStringValue) String? totalQuantity,
    @JsonKey(name: "totalAmount", fromJson: _toDoubleNullable) double? totalAmount,
    @JsonKey(name: "totalAmountNotSubjectToVat", fromJson: _toDoubleNullable)
    double? totalAmountNotSubjectToVat,
    @JsonKey(name: "totalAmountSubjectToVat", fromJson: _toDoubleNullable)
    double? totalAmountSubjectToVat,
    @JsonKey(name: "vatAmount", fromJson: _toDoubleNullable) double? vatAmount,
    @JsonKey(name: "notMinimumOrder") bool? notMinimumOrder,
    @JsonKey(name: "minOrderAmount", fromJson: _toIntNullable) int? minOrderAmount,
    @JsonKey(name: "totalSavings", fromJson: _toDoubleNullable) double? totalSavings,
    @JsonKey(name: "vatPercentage", fromJson: _toDoubleNullable) double? vatPercentage,
    @JsonKey(name: "bottleTax", fromJson: _toDoubleNullable) double? bottleTax,
    @JsonKey(name: "bottleQuantities", fromJson: _toDoubleNullable) double? bottleQuantities,
    @JsonKey(name: "bottleDeposit", fromJson: _toDoubleNullable) double? bottleDeposit,
    @JsonKey(name: "isFirstOrderFromSupplier") bool? isFirstOrderFromSupplier,
    bool? isProcess,
  }) = _CartProductDataResModel;

  factory CartProductDataResModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$CartProductDataResModelFromJson(json);
}

@freezed
class ProductDetail with _$ProductDetail {
  const factory ProductDetail({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "productName") String? productName,
    @JsonKey(name: "images") List<Image>? images,
    @JsonKey(name: "quantity", fromJson: _toIntNullable) int? quantity,
    @JsonKey(name: "supplierId") String? supplierId,
  }) = _ProductDetail;

  factory ProductDetail.fromJson(Map<String, dynamic> json) => _$ProductDetailFromJson(json);
}

@freezed
class Image with _$Image {
  const factory Image({
    @JsonKey(name: "imageUrl") String? imageUrl,
    @JsonKey(name: "order", fromJson: _toIntNullable) int? order,
  }) = _Image;

  factory Image.fromJson(Map<String, dynamic> json) => _$ImageFromJson(json);
}

@freezed
class Sales with _$Sales {
  const factory Sales({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "salesName") String? salesName,
    @JsonKey(name: "discountPercentage", fromJson: _toIntNullable) int? discountPercentage,
  }) = _Sales;

  factory Sales.fromJson(Map<String, dynamic> json) => _$SalesFromJson(json);
}

@freezed
class Suppliers with _$Suppliers {
  const factory Suppliers({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "contactName") String? contactName,
  }) = _Suppliers;

  factory Suppliers.fromJson(Map<String, dynamic> json) => _$SuppliersFromJson(json);
}

double? _toDoubleNullable(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

int? _toIntNullable(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}

String? _toStringValue(dynamic value) {
  if (value == null) return null;
  return value.toString();
}
