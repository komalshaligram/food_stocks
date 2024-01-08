
import 'package:freezed_annotation/freezed_annotation.dart';
part 'export_wallet_transactions_req_model.freezed.dart';
part 'export_wallet_transactions_req_model.g.dart';

@freezed
class ExportWalletTransactionsReqModel with _$ExportWalletTransactionsReqModel {
  const factory ExportWalletTransactionsReqModel({

    String? exportType,

    String? responseType,

    String? userId,

    String? startDate,

    String? endDate,
  }) = _ExportWalletTransactionsReqModel;

  factory ExportWalletTransactionsReqModel.fromJson(Map<String, dynamic> json) => _$ExportWalletTransactionsReqModelFromJson(json);
}
