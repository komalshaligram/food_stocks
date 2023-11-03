import 'package:freezed_annotation/freezed_annotation.dart';
part 'update_cart_req_model.freezed.dart';
part 'update_cart_req_model.g.dart';


@freezed
class UpdateCartReqModel with _$UpdateCartReqModel {
  const factory UpdateCartReqModel({
    @JsonKey(name: "productId")
    String? productId,
    @JsonKey(name: "quantity")
    int? quantity,
    @JsonKey(name: "supplierId")
    String? supplierId,
    @JsonKey(name: "saleId")
    String? saleId,
    @JsonKey(name: "cartId")
    String? cartId,
    @JsonKey(name: "id")
    String? id,
  }) = _UpdateCartReqModel;

  factory UpdateCartReqModel.fromJson(Map<String, dynamic> json) => _$UpdateCartReqModelFromJson(json);
}
