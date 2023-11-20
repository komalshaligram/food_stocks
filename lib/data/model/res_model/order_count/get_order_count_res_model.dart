

import 'package:freezed_annotation/freezed_annotation.dart';
part 'get_order_count_res_model.freezed.dart';
part 'get_order_count_res_model.g.dart';



@freezed
class GetOrderCountResModel with _$GetOrderCountResModel {
  const factory GetOrderCountResModel({
    @JsonKey(name: "status")
    int? status,
    @JsonKey(name: "message")
    String? message,
    @JsonKey(name: "data")
    int? data,
  }) = _GetOrderCountResModel;

  factory GetOrderCountResModel.fromJson(Map<String, dynamic> json) => _$GetOrderCountResModelFromJson(json);
}
