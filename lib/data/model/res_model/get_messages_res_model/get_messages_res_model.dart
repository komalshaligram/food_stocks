
import 'package:freezed_annotation/freezed_annotation.dart';


part 'get_messages_res_model.freezed.dart';
part 'get_messages_res_model.g.dart';



@freezed
class GetMessagesResModel with _$GetMessagesResModel {
  const factory GetMessagesResModel({
    @JsonKey(name: "status")
    int? status,
    @JsonKey(name: "data")
    List<MessageData>? data,
    @JsonKey(name: "metaData")
    MetaData? metaData,
    @JsonKey(name: "message")
    String? message,
  }) = _GetMessagesResModel;

  factory GetMessagesResModel.fromJson(Map<String, dynamic> json) => _$GetMessagesResModelFromJson(json);
}

@freezed
class MessageData with _$MessageData{
  const factory MessageData({
    @JsonKey(name: "_id")
    String? id,
    @JsonKey(name: "isRead")
    bool? isRead,
    @JsonKey(name: "isSuccess")
    bool? isSuccess,
    @JsonKey(name: "type")
    String? type,
    @JsonKey(name: "usermessages")
    Order? usermessages,
    @JsonKey(name: "order")
    Order? order,
    @JsonKey(name: "message")
    Message? message,
    @JsonKey(name: "createdAt")
    String? createdAt,
    @JsonKey(name: "updatedAt")
    String? updatedAt,
  }) = _MessageData;

  factory MessageData.fromJson(Map<String, dynamic> json) => _$MessageDataFromJson(json);
}

@freezed
class Message with _$Message {
  const factory Message({
    @JsonKey(name: "_id")
    String? id,
    @JsonKey(name: "supplierSystem")
    String? supplierSystem,
    @JsonKey(name: "subPageSupplier")
    String? subPageSupplier,
    @JsonKey(name: "clientApp")
    String? clientApp,
    @JsonKey(name: "subPageClient")
    String? subPageClient,
    @JsonKey(name: "title")
    String? title,
    @JsonKey(name: "messageImage")
    String? messageImage,
    @JsonKey(name: "summary")
    String? summary,
    @JsonKey(name: "body")
    String? body,
    String? mainPage,
    String? subPage,
    @JsonKey(name: "id")
    String? navigationId,
    String? link,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);
}

@freezed
class Order with _$Order {
  const factory Order() = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
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
