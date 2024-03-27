
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
    String? id,
    @JsonKey(name: "totalAmount")
    double? totalAmount,
    int? suppliers,
    int? bottleQuantities,

  }) = _Cart;

  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);
}

@freezed
class Datum with _$Datum {
  const factory Datum({
    @JsonKey(name: "_id")
    String? id,
    @JsonKey(name: "productDetails")
    ProductDetails? productDetails,
    @JsonKey(name: "cartProductId")
    String? cartProductId,
    @JsonKey(name: "suppliers")
    List<Supplier>? suppliers,
    @JsonKey(name: "productStock")
    double? productStock,
    @JsonKey(name: "productPrice")
    double? productPrice,
    @JsonKey(name: "sales")
    List<Sale>? sales,
    @JsonKey(name: "totalQuantity")
    int? totalQuantity,
    @JsonKey(name: "totalAmount")
    double? totalAmount,
    @JsonKey(name: "note")
    String? note,
    String? lowStock,
    bool? isPesach
  }) = _Datum;

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);
}

@freezed
class ProductDetails with _$ProductDetails {
  const factory ProductDetails({
    @JsonKey(name: "_id")
    String? id,
    @JsonKey(name: "productName")
    String? productName,
    @JsonKey(name: "mainImage")
    String? mainImage,
    @JsonKey(name: "itemsWeight")
    double? itemsWeight,
    @JsonKey(name: "images")
    List<Image>? images,
    @JsonKey(name: "scales")
    String? scales,
    @JsonKey(name: "numberOfUnit")
    int? numberOfUnit,
  }) = _ProductDetails;

  factory ProductDetails.fromJson(Map<String, dynamic> json) => _$ProductDetailsFromJson(json);
}

@freezed
class Image with _$Image {
  const factory Image({
    @JsonKey(name: "imageUrl")
    String? imageUrl,
    @JsonKey(name: "order")
    int? order,
  }) = _Image;

  factory Image.fromJson(Map<String, dynamic> json) => _$ImageFromJson(json);
}

@freezed
class Sale with _$Sale {
  const factory Sale({
    @JsonKey(name: "_id")
    String? id,
    @JsonKey(name: "status")
    String? status,
    @JsonKey(name: "supplierDetails")
    String? supplierDetails,
    @JsonKey(name: "salesName")
    String? salesName,
    @JsonKey(name: "discountPercentage")
    double? discountPercentage,
    @JsonKey(name: "salesType")
    String? salesType,
    @JsonKey(name: "salesDescription")
    String? salesDescription,
    @JsonKey(name: "fromDate")
    String? fromDate,
    @JsonKey(name: "endDate")
    String? endDate,
    @JsonKey(name: "salesTerms")
    String? salesTerms,
    @JsonKey(name: "createdBy")
    String? createdBy,
    @JsonKey(name: "updatedBy")
    String? updatedBy,
    @JsonKey(name: "isDeleted")
    bool? isDeleted,
    @JsonKey(name: "createdAt")
    String? createdAt,
    @JsonKey(name: "updatedAt")
    String? updatedAt,
    @JsonKey(name: "__v")
    int? v,
  }) = _Sale;

  factory Sale.fromJson(Map<String, dynamic> json) => _$SaleFromJson(json);
}

@freezed
class Supplier with _$Supplier {
  const factory Supplier({
    @JsonKey(name: "_id")
    String? id,
    @JsonKey(name: "contactName")
    String? contactName,
  }) = _Supplier;

  factory Supplier.fromJson(Map<String, dynamic> json) => _$SupplierFromJson(json);
}
