

import 'package:freezed_annotation/freezed_annotation.dart';
part 'delete_message_req.freezed.dart';
part 'delete_message_req.g.dart';


@freezed
class DeleteMessageReq with _$DeleteMessageReq {
  const factory DeleteMessageReq({
    @JsonKey(name: "notificationIds")
    List<String>? notificationIds,
  }) = _DeleteMessageReq;

  factory DeleteMessageReq.fromJson(Map<String, dynamic> json) => _$DeleteMessageReqFromJson(json);
}
