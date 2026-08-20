import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_all_cart_res_model.freezed.dart';
part 'get_all_cart_res_model.g.dart';

@freezed
class GetAllCartResModel with _$GetAllCartResModel {
  const factory GetAllCartResModel({
    @JsonKey(name: "status") int? status,
    @JsonKey(name: "data") Data? data,
    @JsonKey(name: "message") String? message,
  }) = _GetAllCartResModel;

  factory GetAllCartResModel.fromJson(Map<String, dynamic> json) =>
      _$GetAllCartResModelFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
    @JsonKey(name: "bottleTax") double? bottleTax,
    @JsonKey(name: "vatPercentage") double? vatPercentage,
    @JsonKey(name: "openRefundTotalAmount") double? openRefundTotalAmount,

    @JsonKey(name: "cart") List<Cart>? cart,
    @JsonKey(name: "data") List<Datum>? data,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) =>
      _$DataFromJson(json);
}

@freezed
class Cart with _$Cart {
  const factory Cart({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "totalAmount") double? totalAmount,
    @JsonKey(name: "suppliers") int? suppliers,
    @JsonKey(name: "isBottles") bool? isBottles,
    @JsonKey(name: "bottleQuantities") int? bottleQuantities,
    @JsonKey(name: "draftReturnExists") bool? draftReturnExists,
  }) = _Cart;

  factory Cart.fromJson(Map<String, dynamic> json) =>
      _$CartFromJson(json);
}

@freezed
class Datum with _$Datum {
  const factory Datum({
    @JsonKey(name: "_id") String? id,

    @JsonKey(name: "productDetails")
    ProductDetails? productDetails,

    @JsonKey(name: "cartProductId")
    String? cartProductId,

    @JsonKey(name: "suppliers")
    List<Supplier>? suppliers,

    @JsonKey(name: "productStock")
    double? productStock,

    @JsonKey(name: "lowStockBox")
    int? lowStockBox,

    @JsonKey(name: "sale")
    Sale? sale,

    @JsonKey(name: "productPrice")
    double? productPrice,

    @JsonKey(name: "totalQuantity")
    int? totalQuantity,

    @JsonKey(name: "totalAmount")
    double? totalAmount,

    @JsonKey(name: "totalVatAmount")
    double? totalVatAmount,

    @JsonKey(name: "actualPrice")
    double? actualPrice,

    @JsonKey(name: "discountedprice")
    double? discountedPrice,

    @JsonKey(name: "note")
    String? note,

    @JsonKey(name: "lowStock")
    String? lowStock,

    @JsonKey(name: "isFree")
    bool? isFree,

    bool? isProcess,
  }) = _Datum;

  factory Datum.fromJson(Map<String, dynamic> json) =>
      _$DatumFromJson(json);
}

@freezed
class ProductDetails with _$ProductDetails {
  const factory ProductDetails({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "productName") String? productName,
    @JsonKey(name: "mainImage") String? mainImage,
    @JsonKey(name: "numberOfUnit") int? numberOfUnit,
    @JsonKey(name: "scaleType") String? scaleType,
    @JsonKey(name: "itemsWeight") int? itemsWeight,
    @JsonKey(name: "images") List<dynamic>? images,
    @JsonKey(name: "isPesach") bool? isPesach,
    @JsonKey(name: "nmMashlim") String? nmMashlim,
  }) = _ProductDetails;

  factory ProductDetails.fromJson(Map<String, dynamic> json) =>
      _$ProductDetailsFromJson(json);
}

@freezed
class Sale with _$Sale {
  const factory Sale({
    @JsonKey(name: "isSale") bool? isSale,
    @JsonKey(name: "salePrice") String? salePrice,
    @JsonKey(name: "saleFromDate") String? saleFromDate,
    @JsonKey(name: "saleUntilDate") String? saleUntilDate,
    @JsonKey(name: "saleMaxQuantity") int? saleMaxQuantity,
    @JsonKey(name: "saleMinQuantity") int? saleMinQuantity,
    @JsonKey(name: "saleDescription") String? saleDescription,
  }) = _Sale;

  factory Sale.fromJson(Map<String, dynamic> json) =>
      _$SaleFromJson(json);
}

@freezed
class Supplier with _$Supplier {
  const factory Supplier({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "contactName") String? contactName,
  }) = _Supplier;

  factory Supplier.fromJson(Map<String, dynamic> json) =>
      _$SupplierFromJson(json);
}