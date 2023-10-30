

import 'package:freezed_annotation/freezed_annotation.dart';
part 'get_all_order_res_model.freezed.dart';
part 'get_all_order_res_model.g.dart';

@freezed
class GetAllOrderResModel with _$GetAllOrderResModel {
  const factory GetAllOrderResModel({

    int? status,

    List<Datum>? data,

    MetaData? metaData,

    String? message,
  }) = _GetAllOrderResModel;

  factory GetAllOrderResModel.fromJson(Map<String, dynamic> json) => _$GetAllOrderResModelFromJson(json);
}

@freezed
class Datum with _$Datum {
  const factory Datum({
    @JsonKey(name: "_id")
    String? id,

    Status? status,

    Client? client,

    String? createdAt,

    String? totalAmount,

    String? totalWeight,

    String? surfaceWeight,

    int? products,

    int? suppiers,
  }) = _Datum;

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);
}

@freezed
class Client with _$Client {
  const factory Client({
    @JsonKey(name: "_id")
    String? id,

    String? clientName,
  }) = _Client;

  factory Client.fromJson(Map<String, dynamic> json) => _$ClientFromJson(json);
}

@freezed
class Status with _$Status {
  const factory Status({
    @JsonKey(name: "_id")
    String? id,

    String? statusName,
  }) = _Status;

  factory Status.fromJson(Map<String, dynamic> json) => _$StatusFromJson(json);
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
