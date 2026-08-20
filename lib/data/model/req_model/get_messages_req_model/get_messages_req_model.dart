import 'package:freezed_annotation/freezed_annotation.dart';
part 'get_messages_req_model.freezed.dart';

part 'get_messages_req_model.g.dart';

@freezed
class GetMessagesReqModel with _$GetMessagesReqModel {
  const factory GetMessagesReqModel({
    int? pageNum,
    int? pageLimit,
    String? sortField,
    String? sortOrder,
    String? search,
    String? messageId,
  }) = _GetMessagesReqModel;

  factory GetMessagesReqModel.fromJson(Map<String, dynamic> json) => _$GetMessagesReqModelFromJson(json);
}
