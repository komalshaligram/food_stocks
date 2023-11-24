
import 'package:freezed_annotation/freezed_annotation.dart';
part 'all_wallet_transaction_res_model.freezed.dart';
part 'all_wallet_transaction_res_model.g.dart';


@freezed
class AllWalletTransactionResModel with _$AllWalletTransactionResModel {
  const factory AllWalletTransactionResModel({

    int? status,

    List<Datum>? data,

    MetaData? metaData,

    String? message,
  }) = _AllWalletTransactionResModel;

  factory AllWalletTransactionResModel.fromJson(Map<String, dynamic> json) => _$AllWalletTransactionResModelFromJson(json);
}

@freezed
class Datum with _$Datum {
  const factory Datum({
    @JsonKey(name: "_id")
    String? id,

    String? amount,

    String? username,

    String? orderId,

    String? type,

    String? income,

    String? outcome,

    String? balance,

    String? createdAt,
  }) = _Datum;

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);
}

@freezed
class MetaData with _$MetaData {
  const factory MetaData({

    int? currentPage,

    int? totalFilteredCount,

    int? totalFilteredPage,
  }) = _MetaData;

  factory MetaData.fromJson(Map<String, dynamic> json) => _$MetaDataFromJson(json);
}
