import 'package:freezed_annotation/freezed_annotation.dart';
part 'business_name_model.freezed.dart';
part 'business_name_model.g.dart';

@freezed
class BusinessNameModel with _$BusinessNameModel {
  const factory BusinessNameModel({
    @JsonKey(name: "status") int? status,
    @JsonKey(name: "data") Data? data,
    @JsonKey(name: "message") String? message,
  }) = _BusinessNameModel;

  factory BusinessNameModel.fromJson(Map<String, dynamic> json) => _$BusinessNameModelFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
    @JsonKey(name: "BusinessType") List<BusinessType>? businessType,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
class BusinessType with _$BusinessType {
  const factory BusinessType({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "businessTypeName") String? businessTypeName,
    @JsonKey(name: "isDeleted") bool? isDeleted,
    @JsonKey(name: "businessTypeNumber") int? businessTypeNumber,
    @JsonKey(name: "haveMultiple") bool? haveMultiple,
    @JsonKey(name: "createdAt") String? createdAt,
    @JsonKey(name: "updatedAt") String? updatedAt,
    @JsonKey(name: "__v") int? v,
    @JsonKey(name: "lowerField") String? lowerField,
  }) = _BusinessType;

  factory BusinessType.fromJson(Map<String, dynamic> json) => _$BusinessTypeFromJson(json);
}
