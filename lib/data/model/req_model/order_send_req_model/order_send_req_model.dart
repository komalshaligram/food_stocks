// To parse this JSON data, do
//
//     final orderSendReqModel = orderSendReqModelFromMap(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
part 'order_send_req_model.freezed.dart';
part 'order_send_req_model.g.dart';


@freezed
class OrderSendReqModel with _$OrderSendReqModel {
  const factory OrderSendReqModel({
    @JsonKey(name: "products")
    List<Product>? products,
  }) = _OrderSendReqModel;

  factory OrderSendReqModel.fromJson(Map<String, dynamic> json) => _$OrderSendReqModelFromJson(json);
}

@freezed
class Product with _$Product {
  const factory Product({
    @JsonKey(name: "productId")
    String? productId,
    @JsonKey(name: "quantity")
    int? quantity,
    @JsonKey(name: "supplierId")
    String? supplierId,
    @JsonKey(name: "saleId")
    String? saleId,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}
