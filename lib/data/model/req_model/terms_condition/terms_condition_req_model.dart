import 'package:freezed_annotation/freezed_annotation.dart';
part 'terms_condition_req_model.freezed.dart';
part 'terms_condition_req_model.g.dart';


@freezed
class TermsConditionReqModel with _$TermsConditionReqModel {
  const factory TermsConditionReqModel({
    @JsonKey(name: "id")
    String? id,
    @JsonKey(name: "businessTypeId")
    String? businessTypeId,
    @JsonKey(name: "bankId")
    String? bankId,
    @JsonKey(name: "owner1FullName")
    String? owner1FullName,
    @JsonKey(name: "owner1IsraelId")
    String? owner1IsraelId,
    @JsonKey(name: "owner2FullName")
    String? owner2FullName,
    @JsonKey(name: "owner2IsraelId")
    String? owner2IsraelId,
    @JsonKey(name: "guarantee1FullName")
    String? guarantee1FullName,
    @JsonKey(name: "guarantee1IsraelId")
    String? guarantee1IsraelId,
    @JsonKey(name: "guarantee1Address")
    String? guarantee1Address,
    @JsonKey(name: "guarantee1PhoneNumber")
    String? guarantee1PhoneNumber,
    @JsonKey(name: "guarantee2FullName")
    String? guarantee2FullName,
    @JsonKey(name: "guarantee2IsraelId")
    String? guarantee2IsraelId,
    @JsonKey(name: "guarantee2Address")
    String? guarantee2Address,
    @JsonKey(name: "guarantee2PhoneNumber")
    String? guarantee2PhoneNumber,
    @JsonKey(name: "branchNumber")
    String? branchNumber,
    @JsonKey(name: "accountNumber")
    String? accountNumber,
    @JsonKey(name: "paymentType")
    String? paymentType,
    String? signature,
  }) = _TermsConditionReqModel;

  factory TermsConditionReqModel.fromJson(Map<String, dynamic> json) => _$TermsConditionReqModelFromJson(json);
}
