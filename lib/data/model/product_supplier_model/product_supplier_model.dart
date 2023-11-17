import 'package:food_stock/data/model/supplier_sale_model/supplier_sale_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_supplier_model.freezed.dart';

part 'product_supplier_model.g.dart';

@freezed
class ProductSupplierModel with _$ProductSupplierModel {
  const factory ProductSupplierModel({
    required String supplierId,
    required String companyName,
    @Default([]) List<SupplierSaleModel> supplierSales,
    @Default(0) int quantity,
    @Default(0.0) double basePrice,
    // @Default(false) bool isSelected,
    @Default(-1) int selectedIndex,
  }) = _ProductSupplierModel;

  factory ProductSupplierModel.fromJson(Map<String, dynamic> json) =>
      _$ProductSupplierModelFromJson(json);
}
