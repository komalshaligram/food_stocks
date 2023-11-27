import 'package:freezed_annotation/freezed_annotation.dart';
part 'update_cart_res_model.freezed.dart';
part 'update_cart_res_model.g.dart';

@freezed
class UpdateCartResModel with _$UpdateCartResModel {
  const factory UpdateCartResModel({
    @JsonKey(name: "status")
    int? status,
    @JsonKey(name: "message")
    String? message,
    @JsonKey(name: "data")
    Data? data,
  }) = _UpdateCartResModel;

  factory UpdateCartResModel.fromJson(Map<String, dynamic> json) => _$UpdateCartResModelFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
    @JsonKey(name: "cartProduct")
    CartProduct? cartProduct,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
class CartProduct with _$CartProduct {
  const factory CartProduct({
    @JsonKey(name: "_id")
    String? id,
    @JsonKey(name: "productId")
    String? productId,
    @JsonKey(name: "saleId")
    String? saleId,
    @JsonKey(name: "quantity")
    int? quantity,
    @JsonKey(name: "supplierId")
    String? supplierId,
    @JsonKey(name: "actualPrice")
    double? actualPrice,
    @JsonKey(name: "cartId")
    String? cartId,
    @JsonKey(name: "discountedprice")
    double? discountedprice,
    @JsonKey(name: "createdAt")
    String? createdAt,
    @JsonKey(name: "updatedAt")
    String? updatedAt,
    @JsonKey(name: "__v")
    int? v,
  }) = _CartProduct;

  factory CartProduct.fromJson(Map<String, dynamic> json) => _$CartProductFromJson(json);
}
