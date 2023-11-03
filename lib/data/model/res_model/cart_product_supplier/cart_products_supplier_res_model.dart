
import 'package:freezed_annotation/freezed_annotation.dart';
part 'cart_products_supplier_res_model.freezed.dart';
part 'cart_products_supplier_res_model.g.dart';


@freezed
class CartProductsSupplierResModel with _$CartProductsSupplierResModel {
  const factory CartProductsSupplierResModel({
    @JsonKey(name: "status")
    int? status,
    @JsonKey(name: "data")
    Data? data,
    @JsonKey(name: "message")
    String? message,
  }) = _CartProductsSupplierResModel;

  factory CartProductsSupplierResModel.fromJson(Map<String, dynamic> json) => _$CartProductsSupplierResModelFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
    @JsonKey(name: "cart")
    List<Cart>? cart,
    @JsonKey(name: "data")
    List<Datum>? data,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
class Cart with _$Cart {
  const factory Cart({
    @JsonKey(name: "_id")
    String? id,
    @JsonKey(name: "totalAmount")
    int? totalAmount,
  }) = _Cart;

  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);
}

@freezed
class Datum with _$Datum {
  const factory Datum({
    @JsonKey(name: "_id")
    String? id,
    @JsonKey(name: "suppliers")
    Suppliers? suppliers,
    @JsonKey(name: "productDetails")
    List<ProductDetail>? productDetails,
    @JsonKey(name: "totalQuantity")
    int? totalQuantity,
    @JsonKey(name: "totalAmount")
    int? totalAmount,
  }) = _Datum;

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);
}

@freezed
class ProductDetail with _$ProductDetail {
  const factory ProductDetail({
    @JsonKey(name: "_id")
    String? id,
    @JsonKey(name: "productName")
    String? productName,
    @JsonKey(name: "images")
    List<Image>? images,
  }) = _ProductDetail;

  factory ProductDetail.fromJson(Map<String, dynamic> json) => _$ProductDetailFromJson(json);
}

@freezed
class Image with _$Image {
  const factory Image({
    @JsonKey(name: "imageUrl")
    String? imageUrl,
    @JsonKey(name: "order")
    int? order,
  }) = _Image;

  factory Image.fromJson(Map<String, dynamic> json) => _$ImageFromJson(json);
}

@freezed
class Suppliers with _$Suppliers {
  const factory Suppliers({
    @JsonKey(name: "_id")
    String? id,
    @JsonKey(name: "contactName")
    String? contactName,
  }) = _Suppliers;

  factory Suppliers.fromJson(Map<String, dynamic> json) => _$SuppliersFromJson(json);
}
