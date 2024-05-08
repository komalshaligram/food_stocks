

import 'package:freezed_annotation/freezed_annotation.dart';

part 'supplier_permission_res_model.freezed.dart';
part 'supplier_permission_res_model.g.dart';



@freezed
class SupplierPermissionResModel with _$SupplierPermissionResModel {
  const factory SupplierPermissionResModel({
    @JsonKey(name: "data")
    List<Datum>? data,
    @JsonKey(name: "status")
    int? status,
    @JsonKey(name: "message")
    String? message,
  }) = _SupplierPermissionResModel;

  factory SupplierPermissionResModel.fromJson(Map<String, dynamic> json) => _$SupplierPermissionResModelFromJson(json);
}

@freezed
class Datum with _$Datum {
  const factory Datum({
    @JsonKey(name: "_id")
    String? id,
    @JsonKey(name: "supplierId")
    String? supplierId,
    @JsonKey(name: "createdAt")
    String? createdAt,
    @JsonKey(name: "isAllowed")
    bool? isAllowed,
    @JsonKey(name: "updatedAt")
    String? updatedAt,
    @JsonKey(name: "supplier")
    Supplier? supplier,
  }) = _Datum;

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);
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
