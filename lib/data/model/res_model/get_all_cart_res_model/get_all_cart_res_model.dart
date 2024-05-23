import 'package:meta/meta.dart';
import 'package:freezed_annotation/freezed_annotation.dart';


part 'get_all_cart_res_model.freezed.dart';
part 'get_all_cart_res_model.g.dart';


@freezed
class GetAllCartResModel with _$GetAllCartResModel {
  const factory GetAllCartResModel({
    @JsonKey(name: "status")
    int? status,
    @JsonKey(name: "data")
    Data? data,
    @JsonKey(name: "message")
    String? message,
  }) = _GetAllCartResModel;

  factory GetAllCartResModel.fromJson(Map<String, dynamic> json) => _$GetAllCartResModelFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
    double? vatPercentage,
    double? bottleTax,
    @JsonKey(name: "cart")
    List<Cart>? cart,
    @JsonKey(name: "data")
    List<Datum>? data,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}


@freezed
class Cart with _$Cart {
  const factory Cart({
    @JsonKey(name: "_id")
    required String id,
    @JsonKey(name: "totalAmount")
    required double totalAmount,
    @JsonKey(name: "suppliers")
    required int suppliers,
    @JsonKey(name: "isBottles")
    required bool isBottles,
    @JsonKey(name: "bottleQuantities")
    required int bottleQuantities,
  }) = _Cart;

  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);
}

@freezed
class Datum with _$Datum {
  const factory Datum({
    @JsonKey(name: "_id")
    required String id,
    @JsonKey(name: "productDetails")
    required ProductDetails productDetails,
    @JsonKey(name: "cartProductId")
    required String cartProductId,
    @JsonKey(name: "suppliers")
    required List<Supplier> suppliers,
    @JsonKey(name: "productStock")
    required int productStock,
    @JsonKey(name: "lowStockBox")
    required int lowStockBox,
    @JsonKey(name: "sale")
    required Sale sale,
    @JsonKey(name: "productPrice")
    required double productPrice,
    @JsonKey(name: "totalQuantity")
    required int totalQuantity,
    @JsonKey(name: "totalAmount")
    required double totalAmount,
    @JsonKey(name: "note")
    required String note,
    @JsonKey(name: "lowStock")
    required String lowStock,
  }) = _Datum;

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);
}

@freezed
class ProductDetails with _$ProductDetails {
  const factory ProductDetails({
    @JsonKey(name: "_id")
    required String id,
    @JsonKey(name: "productName")
    required String productName,
    @JsonKey(name: "mainImage")
    required String mainImage,
    @JsonKey(name: "numberOfUnit")
    required int numberOfUnit,
    @JsonKey(name: "itemsWeight")
    required int itemsWeight,
    @JsonKey(name: "images")
    required List<dynamic> images,
    @JsonKey(name: "scales")
    required String scales,
    @JsonKey(name: "isPesach")
    required bool isPesach,
    @JsonKey(name: "nmMashlim")
    required String nmMashlim,
  }) = _ProductDetails;

  factory ProductDetails.fromJson(Map<String, dynamic> json) => _$ProductDetailsFromJson(json);
}

@freezed
class Sale with _$Sale {
  const factory Sale({
    @JsonKey(name: "isSale")
    required bool isSale,
    @JsonKey(name: "salePrice")
    required String salePrice,
    @JsonKey(name: "saleFromDate")
    required String saleFromDate,
    @JsonKey(name: "saleUntilDate")
    required String saleUntilDate,
    @JsonKey(name: "saleMaxQuantity")
    required int saleMaxQuantity,
    @JsonKey(name: "saleDescription")
    required String saleDescription,
  }) = _Sale;

  factory Sale.fromJson(Map<String, dynamic> json) => _$SaleFromJson(json);
}

@freezed
class Supplier with _$Supplier {
  const factory Supplier({
    @JsonKey(name: "_id")
    required String id,
    @JsonKey(name: "contactName")
    required String contactName,
  }) = _Supplier;

  factory Supplier.fromJson(Map<String, dynamic> json) => _$SupplierFromJson(json);
}
