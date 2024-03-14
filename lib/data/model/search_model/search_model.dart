import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_model.freezed.dart';

part 'search_model.g.dart';

@freezed
class SearchModel with _$SearchModel {
  const factory SearchModel({
    required String searchId,
    required String name,
    @Default('') lowStock,
    required SearchTypes searchType,
    @Default('') String image,
    @Default('') String categoryId,
    @Default('') String categoryName,
    @Default('0') String productStock,
    @Default(0) int numberOfUnits,
    @Default(0.0) double priceParUnit,
    @Default(0.0) double priceOfBox,

  }) = _SearchModel;

  factory SearchModel.fromJson(Map<String, dynamic> json) =>
      _$SearchModelFromJson(json);
}

enum SearchTypes {
  category,
  subCategory,
  company,
  supplier,
  product,
  sale,
}
