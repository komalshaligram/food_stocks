

import 'package:freezed_annotation/freezed_annotation.dart';
part 'get_planogram_by_id_model.freezed.dart';
part 'get_planogram_by_id_model.g.dart';



@freezed
class GetPlanogramByIdModel with _$GetPlanogramByIdModel {
  const factory GetPlanogramByIdModel({
    @JsonKey(name: "status")
    int? status,
    @JsonKey(name: "data")
    Data? data,
    @JsonKey(name: "message")
    String? message,
  }) = _GetPlanogramByIdModel;

  factory GetPlanogramByIdModel.fromJson(Map<String, dynamic> json) => _$GetPlanogramByIdModelFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
    @JsonKey(name: "planogram")
    Planogram? planogram,
    @JsonKey(name: "planogramProducts")
    List<PlanogramProduct>? planogramProducts,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
class Planogram with _$Planogram {
  const factory Planogram({
    @JsonKey(name: "_id")
    String? id,
    @JsonKey(name: "planogramName")
    String? planogramName,
    @JsonKey(name: "fromDate")
    DateTime? fromDate,
    @JsonKey(name: "untilDate")
    DateTime? untilDate,
    @JsonKey(name: "categoryId")
    String? categoryId,
    @JsonKey(name: "subCategoryId")
    String? subCategoryId,
    @JsonKey(name: "isDeleted")
    bool? isDeleted,
    @JsonKey(name: "createdBy")
    String? createdBy,
    @JsonKey(name: "updatedBy")
    String? updatedBy,
    @JsonKey(name: "createdAt")
    DateTime? createdAt,
    @JsonKey(name: "updatedAt")
    DateTime? updatedAt,
    @JsonKey(name: "__v")
    int? v,
  }) = _Planogram;

  factory Planogram.fromJson(Map<String, dynamic> json) => _$PlanogramFromJson(json);
}

@freezed
class PlanogramProduct with _$PlanogramProduct {
  const factory PlanogramProduct({
    @JsonKey(name: "_id")
    String? id,
    @JsonKey(name: "order")
    int? order,
    @JsonKey(name: "productId")
    String? productId,
    @JsonKey(name: "image")
    String? image,
    @JsonKey(name: "productName")
    String? productName,
  }) = _PlanogramProduct;

  factory PlanogramProduct.fromJson(Map<String, dynamic> json) => _$PlanogramProductFromJson(json);
}
