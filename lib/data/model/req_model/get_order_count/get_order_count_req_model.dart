

import 'package:freezed_annotation/freezed_annotation.dart';
part 'get_order_count_req_model.freezed.dart';
part 'get_order_count_req_model.g.dart';


@freezed
class GetOrderCountReqModel with _$GetOrderCountReqModel {
  const factory GetOrderCountReqModel({

    DateTime? startDate,

    DateTime? endDate,
  }) = _GetOrderCountReqModel;

  factory GetOrderCountReqModel.fromJson(Map<String, dynamic> json) => _$GetOrderCountReqModelFromJson(json);
}
