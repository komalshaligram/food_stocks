

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
    @JsonKey(name: "agentId")
    String? agentId,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

