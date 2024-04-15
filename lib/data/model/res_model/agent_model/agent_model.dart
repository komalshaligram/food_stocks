

import 'package:freezed_annotation/freezed_annotation.dart';
part 'agent_model.freezed.dart';
part 'agent_model.g.dart';


@freezed
class AgentModel with _$AgentModel {
  const factory AgentModel({
    @JsonKey(name: "status")
    int? status,
    @JsonKey(name: "data")
    Data? data,
    @JsonKey(name: "message")
    String? message,
  }) = _AgentModel;

  factory AgentModel.fromJson(Map<String, dynamic> json) => _$AgentModelFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
    @JsonKey(name: "Agent")
    List<Agent>? agent,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
class Agent with _$Agent {
  const factory Agent({
    @JsonKey(name: "_id")
    String? id,
    @JsonKey(name: "agentName")
    String? agentName,
    @JsonKey(name: "agentPhoneNumber")
    String? agentPhoneNumber,
    @JsonKey(name: "isDeleted")
    bool? isDeleted,
    @JsonKey(name: "agentNumber")
    int? agentNumber,
    @JsonKey(name: "createdAt")
    String? createdAt,
    @JsonKey(name: "updatedAt")
    String? updatedAt,
    @JsonKey(name: "__v")
    int? v,
    @JsonKey(name: "lowerField")
    String? lowerField,
  }) = _Agent;

  factory Agent.fromJson(Map<String, dynamic> json) => _$AgentFromJson(json);
}
