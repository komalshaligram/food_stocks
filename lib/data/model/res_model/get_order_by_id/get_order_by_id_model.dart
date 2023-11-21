
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
    @JsonKey(name: "createdAt")
    String? createdAt,
    @JsonKey(name: "orderstatus")
    Status? orderstatus,
    @JsonKey(name: "client")
    Client? client,
    @JsonKey(name: "totalAmount")
    int? totalAmount,
    @JsonKey(name: "totalWeight")
    int? totalWeight,
    @JsonKey(name: "surfaceWeight")
    int? surfaceWeight,
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
    @JsonKey(name: "orderDate")
    String? orderDate,
    @JsonKey(name: "totalWeight")
    int? totalWeight,
    @JsonKey(name: "totalPayment")
    int? totalPayment,
    @JsonKey(name: "driverName")
    String? driverName,
    @JsonKey(name: "diverNumber")
    String? diverNumber,
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
    @JsonKey(name: "category")
    Category? category,
    @JsonKey(name: "subCategory")
    SubCategory? subCategory,
    @JsonKey(name: "subSubCategory")
    Category? subSubCategory,
    @JsonKey(name: "pricePerUnit")
    int? pricePerUnit,
    @JsonKey(name: "totalPayment")
    int? totalPayment,
    @JsonKey(name: "discountedPrice")
    int? discountedPrice,
    @JsonKey(name: "itemWeight")
    int? itemWeight,
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
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}

@freezed
class Category with _$Category {
  const factory Category() = _Category;

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
  }) = _SubCategory;

  factory SubCategory.fromJson(Map<String, dynamic> json) => _$SubCategoryFromJson(json);
}
