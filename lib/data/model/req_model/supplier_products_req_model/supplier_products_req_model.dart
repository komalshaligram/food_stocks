import 'package:freezed_annotation/freezed_annotation.dart';
part 'supplier_products_req_model.freezed.dart';

part 'supplier_products_req_model.g.dart';

@freezed
class SupplierProductsReqModel with _$SupplierProductsReqModel {
  const factory SupplierProductsReqModel({
    @JsonKey(name: "supplierId") String? supplierId,
    @JsonKey(name: "pageLimit") int? pageLimit,
    @JsonKey(name: "pageNum") int? pageNum,
    @JsonKey(name: "search") String? search,
    @JsonKey(name: "onlySearch") bool? onlySearch,
    String? sortField,
    String? sortOrder,
  }) = _SupplierProductsReqModel;

  factory SupplierProductsReqModel.fromJson(Map<String, dynamic> json) => _$SupplierProductsReqModelFromJson(json);
}
