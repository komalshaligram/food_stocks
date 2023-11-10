

import 'package:freezed_annotation/freezed_annotation.dart';
part 'all_wallet_transaction_req_model.freezed.dart';
part 'all_wallet_transaction_req_model.g.dart';

@freezed
class AllWalletTransactionReqModel with _$AllWalletTransactionReqModel {
  const factory AllWalletTransactionReqModel({
    @JsonKey(name: "year")
    int? year,
    @JsonKey(name: "month")
    int? month,
    @JsonKey(name: "userId")
    String? userId,
  }) = _AllWalletTransactionReqModel;

  factory AllWalletTransactionReqModel.fromJson(Map<String, dynamic> json) => _$AllWalletTransactionReqModelFromJson(json);
}
