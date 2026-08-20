import 'package:freezed_annotation/freezed_annotation.dart';
part 'profile_details_req_model.freezed.dart';
part 'profile_details_req_model.g.dart';

@freezed
class ProfileDetailsReqModel with _$ProfileDetailsReqModel {
  const factory ProfileDetailsReqModel({
    @JsonKey(name: "_id") String? id,
  }) = _ProfileDetailsReqModel;

  factory ProfileDetailsReqModel.fromJson(Map<String, dynamic> json) => _$ProfileDetailsReqModelFromJson(json);
}
