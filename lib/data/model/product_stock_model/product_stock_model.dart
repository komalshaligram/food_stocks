import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_stock_model.freezed.dart';

part 'product_stock_model.g.dart';

@freezed
class ProductStockModel with _$ProductStockModel {
  const factory ProductStockModel({
    required String productId,
    @Default('') String productSupplierIds,
    @Default('') String productSaleId,
    @Default(0) int quantity,
    @Default('') String note,
    @Default(false) bool isNoteOpen,
    @Default(0) dynamic stock,
    @Default(0.0) double totalPrice,
    // @Default(false) bool isBarcodeProduct,
  }) = _ProductStockModel;

  factory ProductStockModel.fromJson(Map<String, dynamic> json) =>
      _$ProductStockModelFromJson(json);
}