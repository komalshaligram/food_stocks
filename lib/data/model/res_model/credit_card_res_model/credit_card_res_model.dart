import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';
part 'credit_card_res_model.freezed.dart';
part 'credit_card_res_model.g.dart';

CreditCardResModel creditCardResModelFromJson(String str) => CreditCardResModel.fromJson(json.decode(str));

String creditCardResModelToJson(CreditCardResModel data) => json.encode(data.toJson());

@freezed
class CreditCardResModel with _$CreditCardResModel {
  const factory CreditCardResModel({
    @JsonKey(name: "status") required int status,
    @JsonKey(name: "message") required String message,
    @JsonKey(name: "data") required Data data,
  }) = _CreditCardResModel;

  factory CreditCardResModel.fromJson(Map<String, dynamic> json) => _$CreditCardResModelFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
    @JsonKey(name: "_id") required String id,
    @JsonKey(name: "clientDetail") required ClientDetail clientDetail,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
class ClientDetail with _$ClientDetail {
  const factory ClientDetail({
    @JsonKey(name: "creditCard") required CreditCard creditCard,
    @JsonKey(name: "paymentType") required String paymentType,
  }) = _ClientDetail;

  factory ClientDetail.fromJson(Map<String, dynamic> json) => _$ClientDetailFromJson(json);
}

@freezed
class CreditCard with _$CreditCard {
  const factory CreditCard({
    @JsonKey(name: "cardNumber") required String cardNumber,
    @JsonKey(name: "expireDate") required String expireDate,
  }) = _CreditCard;

  factory CreditCard.fromJson(Map<String, dynamic> json) => _$CreditCardFromJson(json);
}
