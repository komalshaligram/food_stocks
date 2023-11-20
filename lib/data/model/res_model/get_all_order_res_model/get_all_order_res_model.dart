

import 'package:freezed_annotation/freezed_annotation.dart';
part 'get_all_order_res_model.freezed.dart';
part 'get_all_order_res_model.g.dart';

@freezed
class GetAllOrderResModel with _$GetAllOrderResModel {
  const factory GetAllOrderResModel({
    @JsonKey(name: "status")
    int? status,
    @JsonKey(name: "data")
    List<Datum>? data,
    @JsonKey(name: "metaData")
    MetaData? metaData,
    @JsonKey(name: "message")
    String? message,
  }) = _GetAllOrderResModel;

  factory GetAllOrderResModel.fromJson(Map<String, dynamic> json) => _$GetAllOrderResModelFromJson(json);
}

@freezed
class Datum with _$Datum {
  const factory Datum({
    @JsonKey(name: "_id")
    String? id,
    @JsonKey(name: "orderNumber")
    int? orderNumber,
    @JsonKey(name: "status")
    Status? status,
    @JsonKey(name: "client")
    Client? client,
    @JsonKey(name: "createdAt")
    String? createdAt,
    @JsonKey(name: "totalAmount")
    String? totalAmount,
    @JsonKey(name: "totalWeight")
    String? totalWeight,
    @JsonKey(name: "surfaceWeight")
    String? surfaceWeight,
    @JsonKey(name: "products")
    int? products,
    @JsonKey(name: "suppliers")
    int? suppliers,
    @JsonKey(name: "noOfIssues")
    int? noOfIssues,
    @JsonKey(name: "isIssue")
    bool? isIssue,
  }) = _Datum;

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);
}

@freezed
class Client with _$Client {
  const factory Client({
    @JsonKey(name: "_id")
    String? id,
    @JsonKey(name: "clientName")
    String? clientName,
  }) = _Client;

  factory Client.fromJson(Map<String, dynamic> json) => _$ClientFromJson(json);
}

@freezed
class Status with _$Status {
  const factory Status({
    @JsonKey(name: "_id")
    String? id,
    @JsonKey(name: "statusName")
    String? statusName,
  }) = _Status;

  factory Status.fromJson(Map<String, dynamic> json) => _$StatusFromJson(json);
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
