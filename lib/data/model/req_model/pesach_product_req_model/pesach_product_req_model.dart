import 'package:freezed_annotation/freezed_annotation.dart';
part 'pesach_product_req_model.freezed.dart';

part 'pesach_product_req_model.g.dart';

@freezed
class PesachProductReqModel with _$PesachProductReqModel {
  const factory PesachProductReqModel({
    int? pageLimit,
    int? pageNum,
    bool? onlySearch,
    bool? isPesach,
    String? sortField,
    String? sortOrder,
  }) = _PesachProductReqModel;

  factory PesachProductReqModel.fromJson(Map<String, dynamic> json) => _$PesachProductReqModelFromJson(json);
}
