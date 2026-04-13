import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_agent_stores_no_minimum_res_model.freezed.dart';
part 'update_agent_stores_no_minimum_res_model.g.dart';



UpdateAgentStoresNoMinimumResModel updateAgentStoresNoMinimumResModelFromJson(String str) =>
    UpdateAgentStoresNoMinimumResModel.fromJson(json.decode(str));

String updateAgentStoresNoMinimumResModelToJson(UpdateAgentStoresNoMinimumResModel data) =>
    json.encode(data.toJson());

@freezed
class UpdateAgentStoresNoMinimumResModel with _$UpdateAgentStoresNoMinimumResModel {
  const factory UpdateAgentStoresNoMinimumResModel({
    int? status,
    UpdateStoreData? data,
    String? message,
  }) = _UpdateAgentStoresNoMinimumResModel;

  factory UpdateAgentStoresNoMinimumResModel.fromJson(Map<String, dynamic> json) =>
      _$UpdateAgentStoresNoMinimumResModelFromJson(json);
}

@freezed
class UpdateStoreData with _$UpdateStoreData {
  const factory UpdateStoreData({
    UpdatedStore? updatedStore,
  }) = _UpdateStoreData;

  factory UpdateStoreData.fromJson(Map<String, dynamic> json) =>
      _$UpdateStoreDataFromJson(json);
}

@freezed
class UpdatedStore with _$UpdatedStore {
  const factory UpdatedStore({
    @JsonKey(name: "_id") String? id,
    String? supplierId,
    String? clientId,
    String? customerComaxId,
    int? supplierCustomerNumber,
    String? supplierCustomerName,
    int? customerRivchitId,
    bool? isAllowed,
    bool? isNoMinimum,
    bool? isBankCheck,
    bool? isBankTransfer,
    bool? isCreditCard,
    bool? isWallet,
    bool? isDeleted,
    bool? isShowPesachOnly,
    int? noMinimumOrderHours,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UpdatedStore;

  factory UpdatedStore.fromJson(Map<String, dynamic> json) =>
      _$UpdatedStoreFromJson(json);
}