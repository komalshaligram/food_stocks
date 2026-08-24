import 'package:freezed_annotation/freezed_annotation.dart';
part 'suppliers_req_model.freezed.dart';

part 'suppliers_req_model.g.dart';

@freezed
class SuppliersReqModel with _$SuppliersReqModel {
  const factory SuppliersReqModel({
    @JsonKey(name: "pageNum") int? pageNum,
    @JsonKey(name: "pageLimit") int? pageLimit,
    @JsonKey(name: "search") String? search,
  }) = _SuppliersReqModel;

  factory SuppliersReqModel.fromJson(Map<String, dynamic> json) => _$SuppliersReqModelFromJson(json);
}