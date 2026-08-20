import 'package:freezed_annotation/freezed_annotation.dart';
part 'bank_info_req_model.freezed.dart';
part 'bank_info_req_model.g.dart';

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
