import 'package:freezed_annotation/freezed_annotation.dart';
part 'product_sales_req_model.freezed.dart';

part 'product_sales_req_model.g.dart';

@freezed
class ProductSalesReqModel with _$ProductSalesReqModel {
  const factory ProductSalesReqModel({
    @JsonKey(name: "pageNum") int? pageNum,
    @JsonKey(name: "pageLimit") int? pageLimit,
    @JsonKey(name: "search") String? search,
  }) = _ProductSalesReqModel;

  factory ProductSalesReqModel.fromJson(Map<String, dynamic> json) => _$ProductSalesReqModelFromJson(json);
}
