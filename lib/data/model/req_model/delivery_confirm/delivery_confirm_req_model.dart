

import 'package:freezed_annotation/freezed_annotation.dart';
part 'delivery_confirm_req_model.freezed.dart';
part 'delivery_confirm_req_model.g.dart';


@freezed
class DeliveryConfirmReqModel with _$DeliveryConfirmReqModel {
  const factory DeliveryConfirmReqModel({
    String? signature,
    String? supplierId,
  }) = _DeliveryConfirmReqModel;

  factory DeliveryConfirmReqModel.fromJson(Map<String, dynamic> json) => _$DeliveryConfirmReqModelFromJson(json);
}
