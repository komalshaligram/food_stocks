import 'package:freezed_annotation/freezed_annotation.dart';
part 'credit_card_req_model.freezed.dart';
part 'credit_card_req_model.g.dart';

@freezed
class CreditCardReqModel with _$CreditCardReqModel {
  const factory CreditCardReqModel({
    @JsonKey(name: 'expDate_YY')
    String? expDateYy,

    @JsonKey(name: 'expDate_MM')
    String? expDateMm,
    String? cardNum,
  }) = _CreditCardReqModel;

  factory CreditCardReqModel.fromJson(Map<String, dynamic> json) => _$CreditCardReqModelFromJson(json);
}
