import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'bank_info_req_model.freezed.dart';
part 'bank_info_req_model.g.dart';

BankInfoReqModel bankInfoReqModelFromJson(String str) => BankInfoReqModel.fromJson(json.decode(str));

String bankInfoReqModelToJson(BankInfoReqModel data) => json.encode(data.toJson());

@freezed
class BankInfoReqModel with _$BankInfoReqModel {
  const factory BankInfoReqModel({
    String? clientId,
    String? bankId,
    String? branchNumber,
    String? accountNumber,
  }) = _BankInfoReqModel;

  factory BankInfoReqModel.fromJson(Map<String, dynamic> json) => _$BankInfoReqModelFromJson(json);
}
