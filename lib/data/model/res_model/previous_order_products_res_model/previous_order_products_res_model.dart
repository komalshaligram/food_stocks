import 'package:freezed_annotation/freezed_annotation.dart';
part 'previous_order_products_res_model.freezed.dart';
part 'previous_order_products_res_model.g.dart';

@freezed
class PreviousOrderProductsResModel with _$PreviousOrderProductsResModel {
  const factory PreviousOrderProductsResModel({
    int? status,
    String? message,
    @JsonKey(name: "data") List<PreviousOrderProductData>? previousProductData,
    MetaData? metaData,
  }) = _PreviousOrderProductsResModel;

  factory PreviousOrderProductsResModel.fromJson(Map<String, dynamic> json) => _$PreviousOrderProductsResModelFromJson(json);
}

@freezed
class PreviousOrderProductData with _$PreviousOrderProductData {
  const factory PreviousOrderProductData({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "supplierId") String? supplierId,
    @JsonKey(name: "productStock") double? productStock,
    @JsonKey(name: "totalSale") int? totalSale,
    @JsonKey(name: "productPrice") double? productPrice,
    @JsonKey(name: "boxes") double? boxes,
    @JsonKey(name: "lowStock") String? lowStock,
    @JsonKey(name: "mainImage") String? mainImage,
    @JsonKey(name: "isPesach") bool? isPesach,
    @JsonKey(name: "nmMashlim") String? nmMashlim,
    @JsonKey(name: "productName") String? productName,
    @JsonKey(name: "numberOfUnit") int? numberOfUnit,
    @JsonKey(name: "sale") Sale? sale,
    @JsonKey(name: "recommendedRetailPrice") String? recommendedRetailPrice,
    @JsonKey(name: "recommendedConsumerOffer") String? recommendedConsumerOffer,
  }) = _PreviousOrderProductData;

  factory PreviousOrderProductData.fromJson(Map<String, dynamic> json) => _$PreviousOrderProductDataFromJson(json);
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
  }) = _Sale;

  factory Sale.fromJson(Map<String, dynamic> json) => _$SaleFromJson(json);
}

@freezed
class MetaData with _$MetaData {
  const factory MetaData({
    int? currentPage,
    int? totalFilteredCount,
    int? totalFilteredPage,
  }) = _MetaData;

  factory MetaData.fromJson(Map<String, dynamic> json) => _$MetaDataFromJson(json);
}
