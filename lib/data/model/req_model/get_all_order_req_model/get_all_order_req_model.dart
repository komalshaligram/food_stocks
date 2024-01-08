

import 'package:freezed_annotation/freezed_annotation.dart';


part 'get_all_order_req_model.freezed.dart';
part 'get_all_order_req_model.g.dart';


@freezed
class GetAllOrderReqModel with _$GetAllOrderReqModel {
  const factory GetAllOrderReqModel({

    String? search,

    String? orderId,
    int? pageNum,
    int? pageLimit,

  }) = _GetAllOrderReqModel;

  factory GetAllOrderReqModel.fromJson(Map<String, dynamic> json) => _$GetAllOrderReqModelFromJson(json);
}
