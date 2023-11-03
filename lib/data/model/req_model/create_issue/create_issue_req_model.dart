
import 'package:freezed_annotation/freezed_annotation.dart';
part 'create_issue_req_model.freezed.dart';
part 'create_issue_req_model.g.dart';

@freezed
class CreateIssueReqModel with _$CreateIssueReqModel {
  const factory CreateIssueReqModel({
    @JsonKey(name: "signature")
    String? signature,
    @JsonKey(name: "supplierId")
    String? supplierId,
    @JsonKey(name: "products")
    List<Product>? products,
  }) = _CreateIssueReqModel;

  factory CreateIssueReqModel.fromJson(Map<String, dynamic> json) => _$CreateIssueReqModelFromJson(json);
}

@freezed
class Product with _$Product {
  const factory Product({
    @JsonKey(name: "productId")
    String? productId,
    @JsonKey(name: "issue")
    String? issue,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}
