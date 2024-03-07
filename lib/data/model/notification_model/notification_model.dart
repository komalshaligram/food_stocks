
import 'package:freezed_annotation/freezed_annotation.dart';
part 'notification_model.freezed.dart';
part 'notification_model.g.dart';



@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    Data? data,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) => _$NotificationModelFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
    String? id,
    String? appContentMessageId,
    String? type,
    String? userId,
    bool? isRead,
    bool? isSuccess,
    Message? message,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
class Message with _$Message {
  const factory Message({
    String? title,
    String? body,
    String? mainPage,
    String? subPage,
    String? id,
    String? link,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);
}
