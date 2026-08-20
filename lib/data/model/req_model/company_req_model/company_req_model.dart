import 'package:freezed_annotation/freezed_annotation.dart';
part 'company_req_model.freezed.dart';

part 'company_req_model.g.dart';

@freezed
class CompanyReqModel with _$CompanyReqModel {
  const factory CompanyReqModel({
    int? pageNum,
    int? pageLimit,
    String? search,
  }) = _CompanyReqModel;

  factory CompanyReqModel.fromJson(Map<String, dynamic> json) => _$CompanyReqModelFromJson(json);
}
