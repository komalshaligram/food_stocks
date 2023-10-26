// To parse this JSON data, do
//
//     final productSalesResModel = productSalesResModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'product_sales_res_model.freezed.dart';
part 'product_sales_res_model.g.dart';

ProductSalesResModel productSalesResModelFromJson(String str) =>
    ProductSalesResModel.fromJson(json.decode(str));

String productSalesResModelToJson(ProductSalesResModel data) =>
    json.encode(data.toJson());

@freezed
class ProductSalesResModel with _$ProductSalesResModel {
  const factory ProductSalesResModel({
    @JsonKey(name: "status") int? status,
    @JsonKey(name: "data") List<Datum>? data,
    @JsonKey(name: "metaData") MetaData? metaData,
  }) = _ProductSalesResModel;

  factory ProductSalesResModel.fromJson(Map<String, dynamic> json) =>
      _$ProductSalesResModelFromJson(json);
}

@freezed
class Datum with _$Datum {
  const factory Datum({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "category") String? category,
    @JsonKey(name: "subcategories") String? subcategories,
    @JsonKey(name: "subsubcategories") String? subsubcategories,
    @JsonKey(name: "casetypes") String? casetypes,
    @JsonKey(name: "status") Status? status,
    @JsonKey(name: "sku") String? sku,
    @JsonKey(name: "brandName") String? brandName,
    @JsonKey(name: "images") List<Image>? images,
    @JsonKey(name: "mainImage") String? mainImage,
    @JsonKey(name: "numberOfUnit") int? numberOfUnit,
    @JsonKey(name: "productName") String? productName,
    @JsonKey(name: "itemsWeight") int? itemsWeight,
    @JsonKey(name: "createdBy") String? createdBy,
    @JsonKey(name: "updatedBy") String? updatedBy,
    @JsonKey(name: "createdAt") String? createdAt,
    @JsonKey(name: "updatedAt") String? updatedAt,
    @JsonKey(name: "salesName") String? salesName,
    @JsonKey(name: "discountPercentage") int? discountPercentage,
    @JsonKey(name: "salesDescription") String? salesDescription,
    @JsonKey(name: "fromDate") DateTime? fromDate,
    @JsonKey(name: "endDate") DateTime? endDate,
  }) = _Datum;

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);
}

@freezed
class Image with _$Image {
  const factory Image({
    @JsonKey(name: "imageUrl") String? imageUrl,
    @JsonKey(name: "order") int? order,
  }) = _Image;

  factory Image.fromJson(Map<String, dynamic> json) => _$ImageFromJson(json);
}

enum Status {
  @JsonValue("Approved")
  APPROVED,
  @JsonValue("Pending")
  PENDING
}

final statusValues =
    EnumValues({"Approved": Status.APPROVED, "Pending": Status.PENDING});

@freezed
class MetaData with _$MetaData {
  const factory MetaData({
    @JsonKey(name: "currentPage") int? currentPage,
    @JsonKey(name: "totalFilteredCount") int? totalFilteredCount,
    @JsonKey(name: "totalFilteredPage") int? totalFilteredPage,
  }) = _MetaData;

  factory MetaData.fromJson(Map<String, dynamic> json) =>
      _$MetaDataFromJson(json);
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
