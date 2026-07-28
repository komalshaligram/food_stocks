import 'package:freezed_annotation/freezed_annotation.dart';

part 'sale_participating_products_res_model.freezed.dart';
part 'sale_participating_products_res_model.g.dart';

/// Response of `POST /v3/products/getSaleParticipatingProducts`.
/// Lists every product that participates in the same active sale as the tapped
/// product (same sale id + supplier), enriched with sale price, image and the
/// client's current cart quantity — used to fill the minimum from one sheet.
@freezed
class SaleParticipatingProductsResModel with _$SaleParticipatingProductsResModel {
  const factory SaleParticipatingProductsResModel({
    @JsonKey(name: "status") int? status,
    @JsonKey(name: "message") String? message,
    @JsonKey(name: "saleType") String? saleType,
    @JsonKey(name: "isMixedSale") bool? isMixedSale,
    @JsonKey(name: "saleMinQuantity") num? saleMinQuantity,
    @JsonKey(name: "saleMaxQuantity") num? saleMaxQuantity,
    @JsonKey(name: "cartId") String? cartId,
    @JsonKey(name: "products") List<SaleParticipatingProduct>? products,
  }) = _SaleParticipatingProductsResModel;

  factory SaleParticipatingProductsResModel.fromJson(Map<String, dynamic> json) =>
      _$SaleParticipatingProductsResModelFromJson(json);
}

@freezed
class SaleParticipatingProduct with _$SaleParticipatingProduct {
  const factory SaleParticipatingProduct({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "image") String? image,
    @JsonKey(name: "salePrice") String? salePrice,
    @JsonKey(name: "originalPrice") String? originalPrice,
    @JsonKey(name: "numberOfUnit") String? numberOfUnit,
    @JsonKey(name: "scaleType") String? scaleType,
    @JsonKey(name: "productStock") num? productStock,
    @JsonKey(name: "saleMaxQuantity") String? saleMaxQuantity,
    @JsonKey(name: "cartQuantity") num? cartQuantity,
    @JsonKey(name: "cartProductId") String? cartProductId,
    @JsonKey(name: "supplierId") String? supplierId,
    @JsonKey(name: "isCurrent") bool? isCurrent,
  }) = _SaleParticipatingProduct;

  factory SaleParticipatingProduct.fromJson(Map<String, dynamic> json) =>
      _$SaleParticipatingProductFromJson(json);
}
