import 'package:freezed_annotation/freezed_annotation.dart';
part 'get_all_cart_res_model.freezed.dart';
part 'get_all_cart_res_model.g.dart';

@freezed
class GetAllCartResModel with _$GetAllCartResModel {
  const factory GetAllCartResModel({
    @JsonKey(name: "status")
    int? status,
    @JsonKey(name: "data")
    Data? data,
    @JsonKey(name: "message")
    String? message,
  }) = _GetAllCartResModel;

  factory GetAllCartResModel.fromJson(Map<String, dynamic> json) => _$GetAllCartResModelFromJson(json);
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
    @JsonKey(name: "productDetails")
    ProductDetails? productDetails,
    @JsonKey(name: "suppliers")
    List<Supplier>? suppliers,
    @JsonKey(name: "totalQuantity")
    int? totalQuantity,
    @JsonKey(name: "totalAmount")
    int? totalAmount,
  }) = _Datum;

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);
}

@freezed
class ProductDetails with _$ProductDetails {
  const factory ProductDetails({
    @JsonKey(name: "_id")
    String? id,
    @JsonKey(name: "productName")
    String? productName,
    @JsonKey(name: "images")
    List<Image>? images,
    @JsonKey(name: "mainImage")
    String? mainImage,
  }) = _ProductDetails;

  factory ProductDetails.fromJson(Map<String, dynamic> json) => _$ProductDetailsFromJson(json);
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
class Supplier with _$Supplier {
  const factory Supplier({
    @JsonKey(name: "_id")
    String? id,
    @JsonKey(name: "contactName")
    String? contactName,
  }) = _Supplier;

  factory Supplier.fromJson(Map<String, dynamic> json) => _$SupplierFromJson(json);
}
