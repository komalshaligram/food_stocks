

import 'package:freezed_annotation/freezed_annotation.dart';
part 'export_wallet_transactions_res_model.freezed.dart';
part 'export_wallet_transactions_res_model.g.dart';


@freezed
class ExportWalletTransactionsResModel with _$ExportWalletTransactionsResModel {
  const factory ExportWalletTransactionsResModel({

    int? status,

    String? data,

    String? message,
  }) = _ExportWalletTransactionsResModel;

  factory ExportWalletTransactionsResModel.fromJson(Map<String, dynamic> json) => _$ExportWalletTransactionsResModelFromJson(json);
}
