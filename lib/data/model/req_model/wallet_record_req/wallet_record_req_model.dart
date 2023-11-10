

import 'package:freezed_annotation/freezed_annotation.dart';
part 'wallet_record_req_model.freezed.dart';
part 'wallet_record_req_model.g.dart';



@freezed
class WalletRecordReqModel with _$WalletRecordReqModel {
  const factory WalletRecordReqModel({
    @JsonKey(name: "userId")
    String? userId,
  }) = _WalletRecordReqModel;

  factory WalletRecordReqModel.fromJson(Map<String, dynamic> json) => _$WalletRecordReqModelFromJson(json);
}
