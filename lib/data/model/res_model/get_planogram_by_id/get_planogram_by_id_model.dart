

import 'package:freezed_annotation/freezed_annotation.dart';


part 'get_planogram_by_id_model.freezed.dart';
part 'get_planogram_by_id_model.g.dart';


@freezed
class GetPlanogramByIdModel with _$GetPlanogramByIdModel {
  const factory GetPlanogramByIdModel({
    int? status,
    Data? data,
    String? message,
  }) = _GetPlanogramByIdModel;

  factory GetPlanogramByIdModel.fromJson(Map<String, dynamic> json) => _$GetPlanogramByIdModelFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
    Planogram? planogram,
    List<PlanogramProduct>? planogramProducts,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
class Planogram with _$Planogram {
  const factory Planogram({
    String? id,
    String? planogramName,
    DateTime? fromDate,
    DateTime? untilDate,
    String? categoryId,
    String? subCategoryId,
    bool? isDeleted,
    String? createdBy,
    String? updatedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    String? categoryName,
    String? subCategoryName,
  }) = _Planogram;

  factory Planogram.fromJson(Map<String, dynamic> json) => _$PlanogramFromJson(json);
}

@freezed
class PlanogramProduct with _$PlanogramProduct {
  const factory PlanogramProduct({
    String? id,
    int? order,
    String? productId,
    String? image,
    String? productName,
  }) = _PlanogramProduct;

  factory PlanogramProduct.fromJson(Map<String, dynamic> json) => _$PlanogramProductFromJson(json);
}
