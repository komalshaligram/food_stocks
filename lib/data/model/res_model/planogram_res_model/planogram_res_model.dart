import 'package:freezed_annotation/freezed_annotation.dart';

part 'planogram_res_model.freezed.dart';
part 'planogram_res_model.g.dart';


@freezed
class PlanogramResModel with _$PlanogramResModel {
  const factory PlanogramResModel({
    @JsonKey(name: "status")
    int? status,
    @JsonKey(name: "data")
    List<PlanogramDatum>? data,
    @JsonKey(name: "metaData")
    MetaData? metaData,
    @JsonKey(name: "message")
    String? message,
  }) = _PlanogramResModel;

  factory PlanogramResModel.fromJson(Map<String, dynamic> json) => _$PlanogramResModelFromJson(json);
}

@freezed
class PlanogramDatum with _$PlanogramDatum {
  const factory PlanogramDatum({
    @JsonKey(name: "planogramproducts")
    List<Planogramproduct>? planogramproducts,
    @JsonKey(name: "_id")
    String? id,
    @JsonKey(name: "planogramName")
    String? planogramName,
    @JsonKey(name: "fromDate")
    String? fromDate,
    @JsonKey(name: "untilDate")
    String? untilDate,
  }) = _PlanogramDatum;

  factory PlanogramDatum.fromJson(Map<String, dynamic> json) => _$PlanogramDatumFromJson(json);
}

@freezed
class Planogramproduct with _$Planogramproduct {
  const factory Planogramproduct({
    @JsonKey(name: "_id")
    String? id,
    @JsonKey(name: "supplierId")
    String? supplierId,
    @JsonKey(name: "productStock")
    double? productStock,
    @JsonKey(name: "totalSale")
    int? totalSale,
    @JsonKey(name: "productPrice")
    double? productPrice,
    @JsonKey(name: "boxes")
    double? boxes,
    @JsonKey(name: "lowStock")
    String? lowStock,
    @JsonKey(name: "isPesach")
    bool? isPesach,
    @JsonKey(name: "nmMashlim")
    String? nmMashlim,
    @JsonKey(name: "mainImage")
    String? mainImage,
    @JsonKey(name: "productName")
    String? productName,
    @JsonKey(name: "order")
    int? order,
    @JsonKey(name: "numberOfUnit")
    int? numberOfUnit,
    @JsonKey(name: "sale")
    Sale? sale,
  }) = _Planogramproduct;

  factory Planogramproduct.fromJson(Map<String, dynamic> json) => _$PlanogramproductFromJson(json);
}

@freezed
class Sale with _$Sale {
  const factory Sale({
    @JsonKey(name: "isSale")
    bool? isSale,
    @JsonKey(name: "supplierId")
    String? supplierId,
    @JsonKey(name: "salePrice")
    String? salePrice,
    @JsonKey(name: "saleFromDate")
    String? saleFromDate,
    @JsonKey(name: "saleUntilDate")
    String? saleUntilDate,
    @JsonKey(name: "saleMaxQuantity")
    String? saleMaxQuantity,
    @JsonKey(name: "saleMinQuantity")
    String? saleMinQuantity,
    @JsonKey(name: "saleDescription")
    String? saleDescription,
  }) = _Sale;

  factory Sale.fromJson(Map<String, dynamic> json) => _$SaleFromJson(json);
}

@freezed
class MetaData with _$MetaData {
  const factory MetaData({
    @JsonKey(name: "currentPage")
    int? currentPage,
    @JsonKey(name: "totalFilteredCount")
    int? totalFilteredCount,
    @JsonKey(name: "totalFilteredPage")
    int? totalFilteredPage,
  }) = _MetaData;

  factory MetaData.fromJson(Map<String, dynamic> json) => _$MetaDataFromJson(json);
}