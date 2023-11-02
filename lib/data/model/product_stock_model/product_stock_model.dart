import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_stock_model.freezed.dart';

part 'product_stock_model.g.dart';

@freezed
class ProductStockModel with _$ProductStockModel {
  const factory ProductStockModel({
    required String productId,
    @Default([]) List<String> productSupplierIds,
    @Default(0) int quantity,
    @Default('') String note,
    @Default(0) int stock,
  }) = _ProductStockModel;

  factory ProductStockModel.fromJson(Map<String, dynamic> json) =>
      _$ProductStockModelFromJson(json);
}
