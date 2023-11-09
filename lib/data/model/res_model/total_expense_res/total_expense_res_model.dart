

import 'package:freezed_annotation/freezed_annotation.dart';
part 'total_expense_res_model.freezed.dart';
part 'total_expense_res_model.g.dart';

@freezed
class TotalExpenseResModel with _$TotalExpenseResModel {
  const factory TotalExpenseResModel({
    @JsonKey(name: "status")
    int? status,
    @JsonKey(name: "data")
    List<Datum>? data,
    @JsonKey(name: "totalYearlyExpenses")
    int? totalYearlyExpenses,
    @JsonKey(name: "message")
    String? message,
  }) = _TotalExpenseResModel;

  factory TotalExpenseResModel.fromJson(Map<String, dynamic> json) => _$TotalExpenseResModelFromJson(json);
}

@freezed
class Datum with _$Datum {
  const factory Datum({
    @JsonKey(name: "year")
    int? year,
    @JsonKey(name: "month")
    int? month,
    @JsonKey(name: "totalExpenses")
    int? totalExpenses,
  }) = _Datum;

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);
}
