import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'credit_card_req_model.freezed.dart';
part 'credit_card_req_model.g.dart';

CreditCardReqModel creditCardReqModelFromJson(String str) =>
    CreditCardReqModel.fromJson(json.decode(str));

String creditCardReqModelToJson(CreditCardReqModel data) =>
    json.encode(data.toJson());

@freezed
class CreditCardReqModel with _$CreditCardReqModel {
  const factory CreditCardReqModel({
    String? expDate_YY,
    String? expDate_MM,
    String? cardNum,
  }) = _CreditCardReqModel;

  factory CreditCardReqModel.fromJson(Map<String, dynamic> json) =>
      _$CreditCardReqModelFromJson(json);
}
