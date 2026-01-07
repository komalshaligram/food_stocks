// To parse this JSON data, do
//
//     final profileDetailsResModel = profileDetailsResModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

import '../../req_model/activity_time/activity_time_req_model.dart';
import '../business_name_model/business_name_model.dart';

part 'profile_details_res_model.freezed.dart';
part 'profile_details_res_model.g.dart';

ProfileDetailsResModel profileDetailsResModelFromJson(String str) =>
    ProfileDetailsResModel.fromJson(json.decode(str));

String profileDetailsResModelToJson(ProfileDetailsResModel data) =>
    json.encode(data.toJson());

@freezed
class ProfileDetailsResModel with _$ProfileDetailsResModel {
  const factory ProfileDetailsResModel({
    @JsonKey(name: "status") int? status,
    @JsonKey(name: "data") Data? data,
    @JsonKey(name: "message") String? message,
  }) = _ProfileDetailsResModel;

  factory ProfileDetailsResModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileDetailsResModelFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
    @JsonKey(name: "clients") List<Client>? clients,
    @JsonKey(name: "totalRecords") int? totalRecords,
    @JsonKey(name: "totalPages") int? totalPages,
    @JsonKey(name: "currentPage") int? currentPage,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
class Client with _$Client {
  const factory Client({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "email") String? email,
    @JsonKey(name: "phoneNumber") String? phoneNumber,
    @JsonKey(name: "address") String? address,
    @JsonKey(name: "contactName") String? contactName,
    @JsonKey(name: "logo") String? logo,
    @JsonKey(name: "profileImage") String? profileImage,
    @JsonKey(name: "adminTypeId") String? adminTypeId,
    @JsonKey(name: "clientDetail") ClientDetail? clientDetail,
    @JsonKey(name: "supplierCustomerDetails")  List<SupplierCustomerDetails>? supplierCustomerDetails,
    @JsonKey(name: "roleDetails") RoleDetails? roleDetails,
    @JsonKey(name: "city") City? city,
    @JsonKey(name: "status") Status? status,
  }) = _Client;

  factory Client.fromJson(Map<String, dynamic> json) => _$ClientFromJson(json);
}

@freezed
class City with _$City {
  const factory City({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "cityName") String? cityName,
  }) = _City;

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);
}

@freezed
class ClientDetail with _$ClientDetail {
  const factory ClientDetail({
    @JsonKey(name: "bussinessId") int? bussinessId,
    @JsonKey(name: "bussinessName") String? bussinessName,
    @JsonKey(name: "ownerName") String? ownerName,
    @JsonKey(name: "ownerFirstName") String? ownerFirstName,
    @JsonKey(name: "ownerLastName") String? ownerLastName,
    @JsonKey(name: "clientTypeId") String? clientTypeId,
    @JsonKey(name: "israelId") String? israelId,
    @JsonKey(name: "fax") String? fax,
    @JsonKey(name: "monthlyCredits") String? monthlyCredits,
    @JsonKey(name: "applicationVersion") String? applicationVersion,
    @JsonKey(name: "deviceType") String? deviceType,
    @JsonKey(name: "operationTime") List<OperationTime>? operationTime,
    @JsonKey(name: "personalGuarantee") String? personalGuarantee,
    @JsonKey(name: "promissoryNote") String? promissoryNote,
    @JsonKey(name: "businessCertificate") String? businessCertificate,
    @JsonKey(name: "israelIdImage") String? israelIdImage,
    @JsonKey(name: "forms") dynamic forms,
    @JsonKey(name: "files") dynamic files,
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "clientTypes") List<ClientType>? clientTypes,
    @JsonKey(name: "totalExpense") String? totalExpense,
    @JsonKey(name: "expenseByMonth") String? expenseByMonth,
    @JsonKey(name: "accountNumber") String? accountNumber,
    @JsonKey(name: "branchNumber") String? branchNumber,
    @JsonKey(name: "owner1FullName") String? owner1FullName,
    @JsonKey(name: "owner1IsraelId") String? owner1IsraelId,
    @JsonKey(name: "guarantee1FullName") String? guarantee1FullName,
    @JsonKey(name: "guarantee1IsraelId") String? guarantee1IsraelId,
    @JsonKey(name: "guarantee1Address") String? guarantee1Address,
    @JsonKey(name: "guarantee1PhoneNumber") String? guarantee1PhoneNumber,
    @JsonKey(name: "owner2FullName") String? owner2FullName,
    @JsonKey(name: "owner2IsraelId") String? owner2IsraelId,
    @JsonKey(name: "guarantee2FullName") String? guarantee2FullName,
    @JsonKey(name: "guarantee2IsraelId") String? guarantee2IsraelId,
    @JsonKey(name: "guarantee2Address") String? guarantee2Address,
    @JsonKey(name: "guarantee2PhoneNumber") String? guarantee2PhoneNumber,
    @JsonKey(name: "owner1Signature") String? owner1Signature,
    @JsonKey(name: "owner2Signature") String? owner2Signature,
    @JsonKey(name: "guarantee1Signature") String? guarantee1Signature,
    @JsonKey(name: "guarantee2Signature") String? guarantee2Signature,
    CreditCard? creditCard,
    @JsonKey(name: "availablePaymentTypes")
    required List<String> availablePaymentTypes,
    @JsonKey(name: "paymentType")
    required String paymentType,
    String? streetName,
    String? streetNumber,
    String? zip,
    @JsonKey(name: "isAvailableAllPayments")
    bool? isAvailableAllPayments,
    @JsonKey(name: "bank") Bank? bank,
    @JsonKey(name: "agent") Agent? agent,
    @JsonKey(name: "showClientDataOnApp") bool? showClientDataOnApp,
    //bool? isWalletApproved
  }) = _ClientDetail;

  factory ClientDetail.fromJson(Map<String, dynamic> json) =>
      _$ClientDetailFromJson(json);
}

@freezed
class SupplierCustomerDetails with _$SupplierCustomerDetails {
  const factory SupplierCustomerDetails({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "clientId") String? clientId,
    @JsonKey(name: "supplierId") String? supplierId,
    @JsonKey(name: "createdAt") String? createdAt,
    @JsonKey(name: "isAllowed") bool? isAllowed,
    @JsonKey(name: "isDeleted") bool? isDeleted,
    @JsonKey(name: "supplierCustomerName") String? supplierCustomerName,
    @JsonKey(name: "supplierCustomerNumber") int? supplierCustomerNumber,
    @JsonKey(name: "updatedAt") String? updatedAt,
    @JsonKey(name: "customerComaxId") String? customerComaxId,
    @JsonKey(name: "customerRivchitId") dynamic customerRivchitId,
    @JsonKey(name: "customerCreditcardToken") String? customerCreditcardToken,
    @JsonKey(name: "costumerStatusName") String? costumerStatusName,
    @JsonKey(name: "costumerStatusNumber") dynamic costumerStatusNumber,
    @JsonKey(name: "supplierContactName") String? supplierContactName,
    @JsonKey(name: "lastOrderAboveMinimumAt") String? lastOrderAboveMinimumAt,
    @JsonKey(name: "allowOrdersWithoutMinimum") bool? allowOrdersWithoutMinimum,
    @JsonKey(name: "noMinimumOrderHours") int? noMinimumOrderHours,
    @JsonKey(name: "textHebrew") String? textHebrew,
    @JsonKey(name: "text") String? text,
  }) = _SupplierCustomerDetails;

  factory SupplierCustomerDetails.fromJson(Map<String, dynamic> json) =>
      _$SupplierCustomerDetailsFromJson(json);
}

@freezed
class ClientType with _$ClientType {
  const factory ClientType({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "businessType") String? businessType,
    @JsonKey(name: "__v") int? v,
  }) = _ClientType;

  factory ClientType.fromJson(Map<String, dynamic> json) =>
      _$ClientTypeFromJson(json);
}


@freezed
class CreditCard with _$CreditCard {
  const factory CreditCard({
     String? cardNumber,
     String? expireDate,
  }) = _CreditCard;

  factory CreditCard.fromJson(Map<String, dynamic> json) => _$CreditCardFromJson(json);
}

@freezed
class RoleDetails with _$RoleDetails {
  const factory RoleDetails({
    @JsonKey(name: "adminType") String? adminType,
    // @JsonKey(name: "status") String? status,
  }) = _RoleDetails;

  factory RoleDetails.fromJson(Map<String, dynamic> json) =>
      _$RoleDetailsFromJson(json);
}

@freezed
class Status with _$Status {
  const factory Status({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "statusName") String? statusName,
  }) = _Status;

  factory Status.fromJson(Map<String, dynamic> json) => _$StatusFromJson(json);
}

@freezed
class Bank with _$Bank {
  const factory Bank({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "bankName") String? bankName,
    @JsonKey(name: "bankNumber") String? bankNumber,
    @JsonKey(name: "bankIncrementalNumber") int? bankIncrementalNumber,
}) = _Bank;

factory Bank.fromJson(Map<String, dynamic> json) =>
_$BankFromJson(json);
}

@freezed
class Agent with _$Agent {
  const factory Agent({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "agentName") String? agentName,
    @JsonKey(name: "agentPhoneNumber") String? agentPhoneNumber,
    @JsonKey(name: "agentNumber") int? agentNumber,
    @JsonKey(name: "agentCode") String? agentCode,
  }) = _Agent;

  factory Agent.fromJson(Map<String, dynamic> json) =>
      _$AgentFromJson(json);
}
