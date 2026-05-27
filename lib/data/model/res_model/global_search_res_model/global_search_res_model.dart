import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'global_search_res_model.freezed.dart';

part 'global_search_res_model.g.dart';

GlobalSearchResModel globalSearchResModelFromJson(String str) => GlobalSearchResModel.fromJson(json.decode(str));

String globalSearchResModelToJson(GlobalSearchResModel data) => json.encode(data.toJson());

@freezed
class GlobalSearchResModel with _$GlobalSearchResModel {
  const factory GlobalSearchResModel({
    @JsonKey(name: "status") int? status,
    @JsonKey(name: "data") List<Datum>? data,
    @JsonKey(name: "message") String? message,
  }) = _GlobalSearchResModel;

  factory GlobalSearchResModel.fromJson(Map<String, dynamic> json) => _$GlobalSearchResModelFromJson(json);
}

@freezed
class Datum with _$Datum {
  const factory Datum({
    @JsonKey(name: "isBottle") bool? isBottle,
    @JsonKey(name: "isAlcohol") bool? isAlcohol,
    @JsonKey(name: "productStock") int? productStock,
    @JsonKey(name: "productNameMatch") int? productNameMatch,
    @JsonKey(name: "sale") Sale? sale,
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "supplierId") String? supplierId,
    @JsonKey(name: "productName") String? productName,
    @JsonKey(name: "brandId") String? brandId,
    @JsonKey(name: "productDescription") String? productDescription,
    @JsonKey(name: "mainImage") String? mainImage,
    @JsonKey(name: "qrcode") String? qrcode,
    @JsonKey(name: "sku") String? sku,
    @JsonKey(name: "isPesach") bool? isPesach,
    @JsonKey(name: "nmMashlim") String? nmMashlim,
    @JsonKey(name: "categoriesName") String? categoriesName,
    @JsonKey(name: "subcategories") String? subcategories,
    @JsonKey(name: "productNumber") String? productNumber,
    @JsonKey(name: "boxes") int? boxes,
    @JsonKey(name: "productPrice") double? productPrice,
    @JsonKey(name: "productPriceString") String? productPriceString,
    @JsonKey(name: "lowStock") String? lowStock,
    @JsonKey(name: "recommendedRetailPrice") String? recommendedRetailPrice,
    @JsonKey(name: "recommendedConsumerOffer") String? recommendedConsumerOffer,
    @JsonKey(name: "numberOfUnit") String? numberOfUnit,
    @JsonKey(name: "scaleType") String? scaleType,
  }) = _Datum;

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);
}

@freezed
class Sale with _$Sale {
  const factory Sale({
    @JsonKey(name: "isSale") bool? isSale,
    @JsonKey(name: "isMixedSale") bool? isMixedSale,
    @JsonKey(name: "sameSaleProducts") List<dynamic>? sameSaleProducts,
    @JsonKey(name: "salePrice") String? salePrice,
    @JsonKey(name: "saleFromDate") String? saleFromDate,
    @JsonKey(name: "saleUntilDate") String? saleUntilDate,
    @JsonKey(name: "saleMaxQuantity") String? saleMaxQuantity,
    @JsonKey(name: "saleMinQuantity") String? saleMinQuantity,
    @JsonKey(name: "saleDescription") String? saleDescription,
    @JsonKey(name: "saleSortOrder") int? saleSortOrder,
  }) = _Sale;

  factory Sale.fromJson(Map<String, dynamic> json) => _$SaleFromJson(json);
}

@freezed
class MetaData with _$MetaData {
  const factory MetaData({
    @JsonKey(name: "currentPage") int? currentPage,
    @JsonKey(name: "totalFilteredCount") int? totalFilteredCount,
    @JsonKey(name: "totalFilteredPage") int? totalFilteredPage,
  }) = _MetaData;

  factory MetaData.fromJson(Map<String, dynamic> json) => _$MetaDataFromJson(json);
}
