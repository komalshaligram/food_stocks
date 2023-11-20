// To parse this JSON data, do
//
//     final getMessagesResModel = getMessagesResModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'get_messages_res_model.freezed.dart';

part 'get_messages_res_model.g.dart';

GetMessagesResModel getMessagesResModelFromJson(String str) =>
    GetMessagesResModel.fromJson(json.decode(str));

String getMessagesResModelToJson(GetMessagesResModel data) =>
    json.encode(data.toJson());

@freezed
class GetMessagesResModel with _$GetMessagesResModel {
  const factory GetMessagesResModel({
    @JsonKey(name: "status") int? status,
    @JsonKey(name: "data") List<Message>? data,
    @JsonKey(name: "metaData") MetaData? metaData,
    @JsonKey(name: "message") String? message,
  }) = _GetMessagesResModel;

  factory GetMessagesResModel.fromJson(Map<String, dynamic> json) =>
      _$GetMessagesResModelFromJson(json);
}

@freezed
class Message with _$Message {
  const factory Message({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "contentName") String? contentName,
    @JsonKey(name: "isPushNotification") bool? isPushNotification,
    @JsonKey(name: "isEmail") bool? isEmail,
    @JsonKey(name: "title") String? title,
    @JsonKey(name: "linkToPage") String? linkToPage,
    @JsonKey(name: "subPage") String? subPage,
    @JsonKey(name: "fulltext") String? fulltext,
    @JsonKey(name: "createdAt") String? createdAt,
    @JsonKey(name: "updatedAt") String? updatedAt,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
}

@freezed
class MetaData with _$MetaData {
  const factory MetaData({
    @JsonKey(name: "currentPage") int? currentPage,
    @JsonKey(name: "totalFilteredCount") int? totalFilteredCount,
    @JsonKey(name: "totalFilteredPage") int? totalFilteredPage,
  }) = _MetaData;

  factory MetaData.fromJson(Map<String, dynamic> json) =>
      _$MetaDataFromJson(json);
}
