

import 'package:freezed_annotation/freezed_annotation.dart';
part 'order_send_res_model.freezed.dart';
part 'order_send_res_model.g.dart';


@freezed
class OrderSendResModel with _$OrderSendResModel {
  const factory OrderSendResModel({
    @JsonKey(name: "status")
    int? status,
    @JsonKey(name: "message")
    String? message,
    @JsonKey(name: "data")
    Data? data,
  }) = _OrderSendResModel;

  factory OrderSendResModel.fromJson(Map<String, dynamic> json) => _$OrderSendResModelFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
    @JsonKey(name: "clientId")
    String? clientId,
    @JsonKey(name: "createdBy")
    String? createdBy,
    @JsonKey(name: "updatedBy")
    String? updatedBy,
    @JsonKey(name: "_id")
    String? id,
    @JsonKey(name: "statusId")
    String? statusId,
    @JsonKey(name: "totalAmount")
    SurfaceWeight? totalAmount,
    @JsonKey(name: "totalWeight")
    SurfaceWeight? totalWeight,
    @JsonKey(name: "surfaceWeight")
    SurfaceWeight? surfaceWeight,
    @JsonKey(name: "createdAt")
    String? createdAt,
    @JsonKey(name: "updatedAt")
    String? updatedAt,
    @JsonKey(name: "__v")
    int? v,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
class SurfaceWeight with _$SurfaceWeight {
   factory SurfaceWeight({
    String? numberDecimal,
  }) = _SurfaceWeight;

  factory SurfaceWeight.fromJson(Map<String, dynamic> json) => _$SurfaceWeightFromJson(json);
}
