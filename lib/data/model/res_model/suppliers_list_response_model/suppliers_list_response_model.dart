import 'package:freezed_annotation/freezed_annotation.dart';
part 'suppliers_list_response_model.freezed.dart';
part 'suppliers_list_response_model.g.dart';

@freezed
class SuppliersListResponseModel with _$SuppliersListResponseModel {
  const factory SuppliersListResponseModel({
    @JsonKey(name: "status") int? status,
    @JsonKey(name: "data") SupplierData? data,
    @JsonKey(name: "message") String? message,
  }) = _SuppliersListResponseModel;

  factory SuppliersListResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SuppliersListResponseModelFromJson(json);
}

@freezed
class SupplierData with _$SupplierData {
  const factory SupplierData({
    @JsonKey(name: "supplierList") List<SupplierListData>? supplierList,
    @JsonKey(name: "totalRecords") int? totalRecords,
    @JsonKey(name: "totalPages") int? totalPages,
    @JsonKey(name: "currentPage") int? currentPage,
  }) = _SupplierData;

  factory SupplierData.fromJson(Map<String, dynamic> json) =>
      _$SupplierDataFromJson(json);
}

@freezed
class SupplierListData with _$SupplierListData {
  const factory SupplierListData({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "logo") String? logo,
    @JsonKey(name: "supplierDetail") SupplierDetail? supplierDetail,
  }) = _SupplierListData;

  factory SupplierListData.fromJson(Map<String, dynamic> json) =>
      _$SupplierListDataFromJson(json);
}

@freezed
class SupplierDetail with _$SupplierDetail {
  const factory SupplierDetail({
    @JsonKey(name: "isShowInSupplierApp") bool? isShowInSupplierApp,
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "companyIdNumber") int? companyIdNumber,
    @JsonKey(name: "companyName") String? companyName,
    @JsonKey(name: "displayName") String? displayName,
    @JsonKey(name: "minOrderAmount") int? minOrderAmount,
  }) = _SupplierDetail;

  factory SupplierDetail.fromJson(Map<String, dynamic> json) =>
      _$SupplierDetailFromJson(json);
}