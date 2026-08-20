import 'package:freezed_annotation/freezed_annotation.dart';
part 'global_search_req_model.freezed.dart';

part 'global_search_req_model.g.dart';

@freezed
class GlobalSearchReqModel with _$GlobalSearchReqModel {
  const factory GlobalSearchReqModel({
    @JsonKey(name: "search") String? search,
    String? sortField,
    String? sortOrder,
  }) = _GlobalSearchReqModel;

  factory GlobalSearchReqModel.fromJson(Map<String, dynamic> json) => _$GlobalSearchReqModelFromJson(json);
}
