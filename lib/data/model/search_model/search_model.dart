import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_model.freezed.dart';

part 'search_model.g.dart';

@freezed
class SearchModel with _$SearchModel {
  const factory SearchModel({
    required String searchId,
    required String name,
    @Default('') String image,
  }) = _SearchModel;

  factory SearchModel.fromJson(Map<String, dynamic> json) =>
      _$SearchModelFromJson(json);
}
