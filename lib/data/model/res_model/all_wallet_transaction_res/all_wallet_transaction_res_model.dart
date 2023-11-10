import 'package:freezed_annotation/freezed_annotation.dart';
part 'all_wallet_transaction_res_model.freezed.dart';
part 'all_wallet_transaction_res_model.g.dart';


@freezed
class AllWalletTransactionResModel with _$AllWalletTransactionResModel {
  const factory AllWalletTransactionResModel({
    @JsonKey(name: "status")
    int? status,
    @JsonKey(name: "data")
    List<Datum>? data,
    @JsonKey(name: "metaData")
    MetaData? metaData,
    @JsonKey(name: "message")
    String? message,
  }) = _AllWalletTransactionResModel;

  factory AllWalletTransactionResModel.fromJson(Map<String, dynamic> json) => _$AllWalletTransactionResModelFromJson(json);
}

@freezed
class Datum with _$Datum {
  const factory Datum({
    @JsonKey(name: "_id")
    String? id,
    @JsonKey(name: "amount")
    String? amount,
    @JsonKey(name: "Username")
    String? username,
    @JsonKey(name: "orderId")
    String? orderId,
    @JsonKey(name: "type")
    String? type,
    @JsonKey(name: "income")
    String? income,
    @JsonKey(name: "outcome")
    int? outcome,
    @JsonKey(name: "balance")
    int? balance,
    @JsonKey(name: "createdAt")
    String? createdAt,
  }) = _Datum;

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);
}

@freezed
class MetaData with _$MetaData {
  const factory MetaData({
    @JsonKey(name: "currentPage")
    int? currentPage,
    @JsonKey(name: "totalFilteredCount")
    int? totalFilteredCount,
    @JsonKey(name: "totalFilteredPage")
    int? totalFilteredPage,
  }) = _MetaData;

  factory MetaData.fromJson(Map<String, dynamic> json) => _$MetaDataFromJson(json);
}
