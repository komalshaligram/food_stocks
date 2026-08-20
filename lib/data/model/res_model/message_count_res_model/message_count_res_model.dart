import 'package:freezed_annotation/freezed_annotation.dart';
part 'message_count_res_model.freezed.dart';

part 'message_count_res_model.g.dart';

@freezed
class MessageCountResModel with _$MessageCountResModel {
  const factory MessageCountResModel({
    @JsonKey(name: "status") int? status,
    @JsonKey(name: "data") int? data,
    @JsonKey(name: "message") String? message,
  }) = _MessageCountResModel;

  factory MessageCountResModel.fromJson(Map<String, dynamic> json) => _$MessageCountResModelFromJson(json);
}
