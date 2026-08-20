import 'package:freezed_annotation/freezed_annotation.dart';
part 'product_details_req_model.freezed.dart';

part 'product_details_req_model.g.dart';

@freezed
class ProductDetailsReqModel with _$ProductDetailsReqModel {
  const factory ProductDetailsReqModel({
    @JsonKey(name: "params") String? params,
    @JsonKey(name: "isReturn") bool? isReturn,
  }) = _ProductDetailsReqModel;

  factory ProductDetailsReqModel.fromJson(Map<String, dynamic> json) => _$ProductDetailsReqModelFromJson(json);
}
