
import 'package:freezed_annotation/freezed_annotation.dart';
part 'all_wallet_transaction_req_model.freezed.dart';
part 'all_wallet_transaction_req_model.g.dart';


@freezed
class AllWalletTransactionReqModel with _$AllWalletTransactionReqModel {
  const factory AllWalletTransactionReqModel({
    @JsonKey(name: "userId")
    String? userId,
    @JsonKey(name: "pageNum")
    int? pageNum,
    @JsonKey(name: "pageLimit")
    int? pageLimit,
    @JsonKey(name: "startDate")
    DateTime? startDate,
    @JsonKey(name: "endDate")
    DateTime? endDate,
  }) = _AllWalletTransactionReqModel;

  factory AllWalletTransactionReqModel.fromJson(Map<String, dynamic> json) => _$AllWalletTransactionReqModelFromJson(json);
}
