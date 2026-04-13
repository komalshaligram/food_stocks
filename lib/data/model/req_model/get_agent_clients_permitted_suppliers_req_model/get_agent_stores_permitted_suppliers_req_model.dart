import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_agent_stores_permitted_suppliers_req_model.freezed.dart';
part 'get_agent_stores_permitted_suppliers_req_model.g.dart';

@freezed
class GetAgentClientsPermittedSuppliersReqModel
    with _$GetAgentClientsPermittedSuppliersReqModel {
  const factory GetAgentClientsPermittedSuppliersReqModel({
    String? agentPhoneNumber,
  }) = _GetAgentClientsPermittedSuppliersReqModel;

  factory GetAgentClientsPermittedSuppliersReqModel.fromJson(
      Map<String, dynamic> json,
      ) =>
      _$GetAgentClientsPermittedSuppliersReqModelFromJson(json);
}