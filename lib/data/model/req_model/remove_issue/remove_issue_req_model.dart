import 'package:freezed_annotation/freezed_annotation.dart';
part 'remove_issue_req_model.freezed.dart';
part 'remove_issue_req_model.g.dart';


@freezed
class RemoveIssueReqModel with _$RemoveIssueReqModel {
  const factory RemoveIssueReqModel({
    @JsonKey(name: "supplierId")
    String? supplierId,
    @JsonKey(name: "orderId")
    String? orderId,
    @JsonKey(name: "products")
    List<String>? products,
  }) = _RemoveIssueReqModel;

  factory RemoveIssueReqModel.fromJson(Map<String, dynamic> json) => _$RemoveIssueReqModelFromJson(json);
}
