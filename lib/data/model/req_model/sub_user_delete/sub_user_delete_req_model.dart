import 'package:freezed_annotation/freezed_annotation.dart';
part 'sub_user_delete_req_model.freezed.dart';
part 'sub_user_delete_req_model.g.dart';

@freezed
class SubUserDeleteReqModel with _$SubUserDeleteReqModel {
  const factory SubUserDeleteReqModel({
    @JsonKey(name: "clientId") String? clientId,
    @JsonKey(name: "ids") List<String>? ids,
  }) = _SubUserDeleteReqModel;

  factory SubUserDeleteReqModel.fromJson(Map<String, dynamic> json) => _$SubUserDeleteReqModelFromJson(json);
}
