import 'package:freezed_annotation/freezed_annotation.dart';

part 'supplier_sale_model.freezed.dart';

part 'supplier_sale_model.g.dart';

@freezed
class SupplierSaleModel with _$SupplierSaleModel {
  const factory SupplierSaleModel({
    required String saleId,
    @Default('') String saleName,
    @Default(0.0) double salePrice,
    @Default(0.0) double saleDiscount,
    @Default('') String saleDescription,
    @Default(0) int quantity,
    @Default(0) int productStock,
    // @Default(false) bool isSelected,
  }) = _SupplierSaleModel;

  factory SupplierSaleModel.fromJson(Map<String, dynamic> json) =>
      _$SupplierSaleModelFromJson(json);
}
