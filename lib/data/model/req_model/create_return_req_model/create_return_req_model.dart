import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_return_req_model.freezed.dart';
part 'create_return_req_model.g.dart';

@freezed
class CreateReturnReqModel with _$CreateReturnReqModel {
  const factory CreateReturnReqModel({
    List<ReturnProducts>? returnProducts,
    String? applicationName,
    String? clientId,
    String? returnStatusId,
    required dynamic subUserId,
  }) = _CreateReturnReqModel;

  factory CreateReturnReqModel.fromJson(Map<String, dynamic> json) => _$CreateReturnReqModelFromJson(json);
}

@freezed
class ReturnProducts with _$ReturnProducts {
  const factory ReturnProducts({
    List<String>? proofImages,
    int? totalRefund,
    bool? isApproved,
    int? totalUnits,
    String? productName,
    String? barcode,
    String? reasonToReturn,
    String? notes,
    String? productImage
  }) = _ReturnProducts;

  factory ReturnProducts.fromJson(Map<String, dynamic> json) => _$ReturnProductsFromJson(json);
}
