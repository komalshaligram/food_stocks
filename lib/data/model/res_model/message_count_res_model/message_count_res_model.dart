// To parse this JSON data, do
//
//     final messageCountResModel = messageCountResModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'message_count_res_model.freezed.dart';

part 'message_count_res_model.g.dart';

MessageCountResModel messageCountResModelFromJson(String str) =>
    MessageCountResModel.fromJson(json.decode(str));

String messageCountResModelToJson(MessageCountResModel data) =>
    json.encode(data.toJson());

@freezed
class MessageCountResModel with _$MessageCountResModel {
  const factory MessageCountResModel({
    @JsonKey(name: "status") int? status,
    @JsonKey(name: "data") int? data,
    @JsonKey(name: "message") String? message,
  }) = _MessageCountResModel;

  factory MessageCountResModel.fromJson(Map<String, dynamic> json) =>
      _$MessageCountResModelFromJson(json);
}
