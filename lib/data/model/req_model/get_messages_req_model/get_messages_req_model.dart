// To parse this JSON data, do
//
//     final getMessagesReqModel = getMessagesReqModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'get_messages_req_model.freezed.dart';

part 'get_messages_req_model.g.dart';

GetMessagesReqModel getMessagesReqModelFromJson(String str) =>
    GetMessagesReqModel.fromJson(json.decode(str));

String getMessagesReqModelToJson(GetMessagesReqModel data) =>
    json.encode(data.toJson());

@freezed
class GetMessagesReqModel with _$GetMessagesReqModel {
  const factory GetMessagesReqModel({
    @JsonKey(name: "pageNum") int? pageNum,
    @JsonKey(name: "pageLimit") int? pageLimit,
    @JsonKey(name: "sortField") String? sortField,
    @JsonKey(name: "sortOrder") String? sortOrder,
    @JsonKey(name: "search") String? search,
  }) = _GetMessagesReqModel;

  factory GetMessagesReqModel.fromJson(Map<String, dynamic> json) =>
      _$GetMessagesReqModelFromJson(json);
}