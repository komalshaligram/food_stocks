import 'package:freezed_annotation/freezed_annotation.dart';

part 'brand_permission_res_model.freezed.dart';
part 'brand_permission_res_model.g.dart';

@freezed
class BrandPermissionResModel with _$BrandPermissionResModel {
  const factory BrandPermissionResModel({
    @JsonKey(name: "data") List<Datum>? data,
    @JsonKey(name: "status") int? status,
    @JsonKey(name: "message") String? message,
  }) = _BrandPermissionResModel;

  factory BrandPermissionResModel.fromJson(Map<String, dynamic> json) => _$BrandPermissionResModelFromJson(json);
}

@freezed
class Datum with _$Datum {
  const factory Datum({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "subUserId") String? subUserId,
    @JsonKey(name: "brandId") String? brandId,
    @JsonKey(name: "__v") int? v,
    @JsonKey(name: "createdAt") String? createdAt,
    @JsonKey(name: "createdBy") String? createdBy,
    @JsonKey(name: "isAllowed") bool? isAllowed,
    @JsonKey(name: "updatedAt") String? updatedAt,
    @JsonKey(name: "brand") Brand? brand,
  }) = _Datum;

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);
}

@freezed
class Brand with _$Brand {
  const factory Brand({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "brandName") String? brandName,
    @JsonKey(name: "brandLogo") String? brandLogo,
    @JsonKey(name: "isHomePreference") bool? isHomePreference,
    @JsonKey(name: "order") int? order,
    @JsonKey(name: "isDeleted") bool? isDeleted,
    @JsonKey(name: "createdAt") String? createdAt,
    @JsonKey(name: "updatedAt") String? updatedAt,
    @JsonKey(name: "__v") int? v,
    @JsonKey(name: "brandNumber") int? brandNumber,
  }) = _Brand;

  factory Brand.fromJson(Map<String, dynamic> json) => _$BrandFromJson(json);
}
