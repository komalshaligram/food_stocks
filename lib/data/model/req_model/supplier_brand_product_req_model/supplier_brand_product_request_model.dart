import 'package:freezed_annotation/freezed_annotation.dart';
part 'supplier_brand_product_request_model.freezed.dart';

part 'supplier_brand_product_request_model.g.dart';

@freezed
class SupplierBrandProductRequestModel with _$SupplierBrandProductRequestModel {
  const factory SupplierBrandProductRequestModel({
    @JsonKey(name: "supplierId") String? supplierId,
    @JsonKey(name: "pageLimit") int? pageLimit,
    @JsonKey(name: "pageNum") int? pageNum,
    @JsonKey(name: "brandId") String? brandId,
    @JsonKey(name: "categoryId") String? categoryId,
    @JsonKey(name: "subCategoryId") String? subCategoryId,
  }) = _SupplierBrandProductRequestModel;

  factory SupplierBrandProductRequestModel.fromJson(Map<String, dynamic> json) => _$SupplierBrandProductRequestModelFromJson(json);
}