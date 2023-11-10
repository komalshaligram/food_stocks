

import 'package:freezed_annotation/freezed_annotation.dart';
part 'total_expense_req_model.freezed.dart';
part 'total_expense_req_model.g.dart';

@freezed
class TotalExpenseReqModel with _$TotalExpenseReqModel {
  const factory TotalExpenseReqModel({
    @JsonKey(name: "year")
    int? year,
    @JsonKey(name: "userId")
    String? userId,
  }) = _TotalExpenseReqModel;

  factory TotalExpenseReqModel.fromJson(Map<String, dynamic> json) => _$TotalExpenseReqModelFromJson(json);
}
