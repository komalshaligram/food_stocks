import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_return_req_model.freezed.dart';
part 'create_return_req_model.g.dart';

@freezed
class CreateReturnReqModel with _$CreateReturnReqModel {
  const factory CreateReturnReqModel({
    @JsonKey(name:"returnProducts")
    List<ReturnProduct>? returnProducts,
    String? applicationName,
    String? clientId,
    String? supplierId,
    bool? isDraft,
    required dynamic subUserId,
  }) = _CreateReturnReqModel;

  factory CreateReturnReqModel.fromJson(Map<String, dynamic> json) => _$CreateReturnReqModelFromJson(json);
}

@freezed
class ReturnProduct with _$ReturnProduct {
  const factory ReturnProduct({
    List<String>? proofImages,
    int? totalRefund,
    bool? isApproved,
    int? totalUnits,
    String? productName,
    String? barcode,
    String? reasonToReturn,
    String? notes,
    String? productImage,
    String? supplierId
  }) = _ReturnProduct;

  factory ReturnProduct.fromJson(Map<String, dynamic> json) => _$ReturnProductFromJson(json);
}
