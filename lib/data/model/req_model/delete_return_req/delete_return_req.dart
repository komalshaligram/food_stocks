import 'package:freezed_annotation/freezed_annotation.dart';
part 'delete_return_req.freezed.dart';
part 'delete_return_req.g.dart';


@freezed
class DeleteReturnReq with _$DeleteReturnReq {
  const factory DeleteReturnReq({

    List<String>? ids,
  }) = _DeleteReturnReq;

  factory DeleteReturnReq.fromJson(Map<String, dynamic> json) => _$DeleteReturnReqFromJson(json);
}
