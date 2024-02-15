

import 'package:freezed_annotation/freezed_annotation.dart';
part 'get_order_by_id_model.freezed.dart';
part 'get_order_by_id_model.g.dart';



@freezed
class GetOrderByIdModel with _$GetOrderByIdModel {
  const factory GetOrderByIdModel({
    @JsonKey(name: "status")
    int? status,
    @JsonKey(name: "message")
    String? message,
    @JsonKey(name: "data")
    Data? data,
  }) = _GetOrderByIdModel;

  factory GetOrderByIdModel.fromJson(Map<String, dynamic> json) => _$GetOrderByIdModelFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
    @JsonKey(name: "orderData")
    List<OrderDatum>? orderData,
    @JsonKey(name: "ordersBySupplier")
    List<OrdersBySupplier>? ordersBySupplier,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
class OrderDatum with _$OrderDatum {
  const factory OrderDatum({
    @JsonKey(name: "_id")
    String? id,
    double? vatPercentage,
    double? totalVatAmount,
    @JsonKey(name: "createdAt")
    String? createdAt,
    @JsonKey(name: "orderstatus")
    Status? orderstatus,
    @JsonKey(name: "client")
    Client? client,
    @JsonKey(name: "totalAmount")
    double? totalAmount,
    @JsonKey(name: "totalWeight")
    double? totalWeight,
    @JsonKey(name: "surfaceWeight")
    double? surfaceWeight,
    int? bottleQuantities,
    double? bottlePrice,
    double? bottleTax,
    double? vatAmount,

  }) = _OrderDatum;

  factory OrderDatum.fromJson(Map<String, dynamic> json) => _$OrderDatumFromJson(json);
}

@freezed
class Client with _$Client {
  const factory Client({
    @JsonKey(name: "_id")
    String? id,
    @JsonKey(name: "clientName")
    String? clientName,
  }) = _Client;

  factory Client.fromJson(Map<String, dynamic> json) => _$ClientFromJson(json);
}

@freezed
class Status with _$Status {
  const factory Status({
    @JsonKey(name: "_id")
    String? id,

    @JsonKey(name: "statusName")
    String? statusName,
    @JsonKey(name: "createdAt")
    String? createdAt,
    @JsonKey(name: "updatedAt")
    String? updatedAt,
    @JsonKey(name: "__v")
    int? v,
    @JsonKey(name: "isDeleted")
    bool? isDeleted,
    @JsonKey(name:"orderStatusNumber")
    int? orderStatusNumber
  }) = _Status;

  factory Status.fromJson(Map<String, dynamic> json) => _$StatusFromJson(json);
}

@freezed
class OrdersBySupplier with _$OrdersBySupplier {
  const factory OrdersBySupplier({
    @JsonKey(name: "_id")
    String? id,
    @JsonKey(name: "supplierName")
    String? supplierName,
    @JsonKey(name: "deliverStatus")
    Status? deliverStatus,
    @JsonKey(name: "arrivalDate")
    String? arrivalDate,
    @JsonKey(name: "supplierOrderNumber")
    String? supplierOrderNumber,
    @JsonKey(name: "orderDeliveryDate")
    String? orderDeliveryDate,
    @JsonKey(name: "orderDate")
    String? orderDate,
    @JsonKey(name: "totalWeight")
    double? totalWeight,
    @JsonKey(name: "totalPayment")
    double? totalPayment,
    @JsonKey(name: "driverName")
    String? driverName,
    @JsonKey(name: "driverNumber")
    String? driverNumber,
    @JsonKey(name: "signature")
    String? signature,
    @JsonKey(name: "products")
    List<Product>? products,
  }) = _OrdersBySupplier;

  factory OrdersBySupplier.fromJson(Map<String, dynamic> json) => _$OrdersBySupplierFromJson(json);
}

@freezed
class Product with _$Product {
  const factory Product({
    @JsonKey(name: "productId")
    String? productId,
    @JsonKey(name: "productName")
    String? productName,
    @JsonKey(name: "quantity")
    int? quantity,
    @JsonKey(name: "sku")
    String? sku,
    @JsonKey(name: "brand")
    String? brand,
    @JsonKey(name: "scale")
    String? scale,
    @JsonKey(name: "category")
    Category? category,
    @JsonKey(name: "subCategory")
    SubCategory? subCategory,
    @JsonKey(name: "subSubCategory")
    SubSubCategory? subSubCategory,
    @JsonKey(name: "pricePerUnit")
    double? pricePerUnit,
    @JsonKey(name: "totalPayment")
    double? totalPayment,
    @JsonKey(name: "discountedPrice")
    double? discountedPrice,
    @JsonKey(name: "itemWeight")
    double? itemWeight,
    @JsonKey(name: "issueStatus")
    Status? issueStatus,
    @JsonKey(name: "isIssue")
    bool? isIssue,
    @JsonKey(name: "issue")
    String? issue,
    @JsonKey(name: "note")
    String? note,
    @JsonKey(name: "missingQuantity")
    int? missingQuantity,
    @JsonKey(name: "mainImage")
    String? mainImage,
    bool? isBottle,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}

@freezed
class Category with _$Category {
  const factory Category({
    @JsonKey(name: "_id")
    String? id,
    @JsonKey(name: "categoryName")
    String? categoryName,
    @JsonKey(name: "createdAt")
    String? createdAt,
    @JsonKey(name: "updatedAt")
    String? updatedAt,
    @JsonKey(name: "__v")
    int? v,
    @JsonKey(name: "categoryImage")
    String? categoryImage,
    @JsonKey(name: "isHomePreference")
    bool? isHomePreference,
    @JsonKey(name: "order")
    int? order,
    @JsonKey(name: "isDeleted")
    bool? isDeleted,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
}

@freezed
class SubCategory with _$SubCategory {
  const factory SubCategory({
    @JsonKey(name: "_id")
    String? id,
    @JsonKey(name: "subCategoryName")
    String? subCategoryName,
    @JsonKey(name: "parentCategoryId")
    String? parentCategoryId,
    @JsonKey(name: "createdAt")
    String? createdAt,
    @JsonKey(name: "updatedAt")
    String? updatedAt,
    @JsonKey(name: "__v")
    int? v,
    @JsonKey(name: "isDeleted")
    bool? isDeleted,
  }) = _SubCategory;

  factory SubCategory.fromJson(Map<String, dynamic> json) => _$SubCategoryFromJson(json);
}

@freezed
class SubSubCategory with _$SubSubCategory {
  const factory SubSubCategory({
    @JsonKey(name: "_id")
    String? id,
    @JsonKey(name: "subSubCategoryName")
    String? subSubCategoryName,
    @JsonKey(name: "parentCategoryId")
    String? parentCategoryId,
    @JsonKey(name: "subCategoryId")
    String? subCategoryId,
    @JsonKey(name: "createdAt")
    String? createdAt,
    @JsonKey(name: "updatedAt")
    String? updatedAt,
    @JsonKey(name: "__v")
    int? v,
    @JsonKey(name: "isDeleted")
    bool? isDeleted,
  }) = _SubSubCategory;

  factory SubSubCategory.fromJson(Map<String, dynamic> json) => _$SubSubCategoryFromJson(json);
}
