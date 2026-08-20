import 'package:freezed_annotation/freezed_annotation.dart';
part 'get_agent_clients_permitted_suppliers_res_model.freezed.dart';
part 'get_agent_clients_permitted_suppliers_res_model.g.dart';

@freezed
class GetAgentClientsPermittedSuppliersResModel
    with _$GetAgentClientsPermittedSuppliersResModel {
  const factory GetAgentClientsPermittedSuppliersResModel({
    int? status,
    AgentStoreData? data,
    String? message,
  }) = _GetAgentClientsPermittedSuppliersResModel;

  factory GetAgentClientsPermittedSuppliersResModel.fromJson(
      Map<String, dynamic> json) =>
      _$GetAgentClientsPermittedSuppliersResModelFromJson(json);
}

@freezed
class AgentStoreData with _$AgentStoreData {
  const factory AgentStoreData({
    @JsonKey(name: "agentStores") List<AgentStore>? agentStores,
  }) = _AgentStoreData;

  factory AgentStoreData.fromJson(Map<String, dynamic> json) =>
      _$AgentStoreDataFromJson(json);
}

@freezed
class AgentStore with _$AgentStore {
  const factory AgentStore({
    @JsonKey(name: "_id") String? id,
    List<Supplier>? suppliers,
    String? storeName,
    String? storeRepresentativeName,
    String? storePhoneNumber,
    String? address,
  }) = _AgentStore;

  factory AgentStore.fromJson(Map<String, dynamic> json) =>
      _$AgentStoreFromJson(json);
}

@freezed
class Supplier with _$Supplier {
  const factory Supplier({
    @JsonKey(name: "_id") String? id,
    String? logo,
    int? minOrderAmount,
    String? supplierName,
    bool? isNoMinimum,
  }) = _Supplier;

  factory Supplier.fromJson(Map<String, dynamic> json) =>
      _$SupplierFromJson(json);
}