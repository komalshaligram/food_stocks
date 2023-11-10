

import 'package:freezed_annotation/freezed_annotation.dart';
part 'wallet_record_res_model.freezed.dart';
part 'wallet_record_res_model.g.dart';

@freezed
class WalletRecordResModel with _$WalletRecordResModel {
  const factory WalletRecordResModel({
    @JsonKey(name: "status")
    int? status,
    @JsonKey(name: "data")
    Data? data,
    @JsonKey(name: "message")
    String? message,
  }) = _WalletRecordResModel;

  factory WalletRecordResModel.fromJson(Map<String, dynamic> json) => _$WalletRecordResModelFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
    @JsonKey(name: "currentMonth")
    Month? currentMonth,
    @JsonKey(name: "previousMonth")
    Month? previousMonth,
    @JsonKey(name: "totalOrders")
    int? totalOrders,
    @JsonKey(name: "balanceAmount")
    int? balanceAmount,
    @JsonKey(name: "totalCredit")
    int? totalCredit,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
class Month with _$Month {
  const factory Month({
    @JsonKey(name: "year")
    int? year,
    @JsonKey(name: "month")
    int? month,
    @JsonKey(name: "totalExpenses")
    int? totalExpenses,
    @JsonKey(name: "expensePercentage")
    int? expensePercentage,
  }) = _Month;

  factory Month.fromJson(Map<String, dynamic> json) => _$MonthFromJson(json);
}
