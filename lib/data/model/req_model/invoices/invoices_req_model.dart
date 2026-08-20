import 'package:freezed_annotation/freezed_annotation.dart';
part 'invoices_req_model.freezed.dart';
part 'invoices_req_model.g.dart';

@freezed
class InvoicesReqModel with _$InvoicesReqModel {
  const factory InvoicesReqModel({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "pageNum") int? pageNum,
    @JsonKey(name: "pageLimit") int? pageLimit,
  }) = _InvoicesReqModel;

  factory InvoicesReqModel.fromJson(Map<String, dynamic> json) => _$InvoicesReqModelFromJson(json);
}
