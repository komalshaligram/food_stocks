import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_sub_user_req_model.freezed.dart';
part 'get_sub_user_req_model.g.dart';

@freezed
class GetSubUserReqModel with _$GetSubUserReqModel {
  const factory GetSubUserReqModel({
    @JsonKey(name: "clientId") String? clientId,
    @JsonKey(name: "pageNum") int? pageNum,
    @JsonKey(name: "pageLimit") int? pageLimit,
    @JsonKey(name: "subuserId") String? subuserId,
  }) = _GetSubUserReqModel;

  factory GetSubUserReqModel.fromJson(Map<String, dynamic> json) => _$GetSubUserReqModelFromJson(json);
}
