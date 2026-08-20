import 'package:freezed_annotation/freezed_annotation.dart';
part 'planogram_req_model.freezed.dart';

part 'planogram_req_model.g.dart';

@freezed
class PlanogramReqModel with _$PlanogramReqModel {
  const factory PlanogramReqModel({
    int? pageNum,
    int? pageLimit,
    String? sortOrder,
    String? sortField,
    String? subCategoryId,
    String? categoryId,
    @JsonKey(name: "_id") String? id,
  }) = _PlanogramReqModel;

  factory PlanogramReqModel.fromJson(Map<String, dynamic> json) => _$PlanogramReqModelFromJson(json);
}
