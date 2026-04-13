import 'package:freezed_annotation/freezed_annotation.dart';
part 'update_agent_stores_no_minimum_req_model.freezed.dart';
part 'update_agent_stores_no_minimum_req_model.g.dart';

@freezed
class UpdateAgentStoresNoMinimumReqModel with _$UpdateAgentStoresNoMinimumReqModel {
  const factory UpdateAgentStoresNoMinimumReqModel({
    @JsonKey(name: "storeId") String? storeId,
    @JsonKey(name: "supplierId") String? supplierId,
    @JsonKey(name: "isNoMinimum") bool? isNoMinimum,
  }) = _UpdateAgentStoresNoMinimumReqModel;

  factory UpdateAgentStoresNoMinimumReqModel.fromJson(Map<String, dynamic> json) => _$UpdateAgentStoresNoMinimumReqModelFromJson(json);
}
