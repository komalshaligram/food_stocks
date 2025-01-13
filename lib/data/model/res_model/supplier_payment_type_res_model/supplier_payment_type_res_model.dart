import 'package:freezed_annotation/freezed_annotation.dart';

part 'supplier_payment_type_res_model.freezed.dart';
part 'supplier_payment_type_res_model.g.dart';


@freezed
class SupplierPaymentTypeResModel with _$SupplierPaymentTypeResModel {
  const factory SupplierPaymentTypeResModel({
    @JsonKey(name: "status")
    int? status,
    @JsonKey(name: "data")
    Data? data,
    @JsonKey(name: "message")
    String? message,
  }) = _SupplierPaymentTypeResModel;

  factory SupplierPaymentTypeResModel.fromJson(Map<String, dynamic> json) => _$SupplierPaymentTypeResModelFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
    @JsonKey(name: "paymentDetails")
    PaymentDetails? paymentDetails,
  }) = _Data;
  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
class PaymentDetails with _$PaymentDetails {
  const factory PaymentDetails({
    @JsonKey(name: "bankTransferPopupText")
    String? bankTransferPopupText,
    @JsonKey(name: "paymentTypes")
    List<String>? paymentTypes,
  }) = _PaymentDetails;
  factory PaymentDetails.fromJson(Map<String, dynamic> json) => _$PaymentDetailsFromJson(json);
}
