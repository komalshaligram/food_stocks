// To parse this JSON data, do
//
//     final createIssueReqModel = createIssueReqModelFromMap(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_issue_req_model.freezed.dart';

part 'create_issue_req_model.g.dart';

@freezed
class CreateIssueReqModel with _$CreateIssueReqModel {
  const factory CreateIssueReqModel({
 String? supplierId,
    List<Product>? products,
  }) = _CreateIssueReqModel;

  factory CreateIssueReqModel.fromJson(Map<String, dynamic> json) =>
      _$CreateIssueReqModelFromJson(json);
}

@freezed
class Product with _$Product {
  const factory Product({
 String? productId,
  String? issue,
   int? missingQuantity,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}
