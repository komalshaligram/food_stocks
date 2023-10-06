

import 'package:freezed_annotation/freezed_annotation.dart';
part 'city_list_res_model.freezed.dart';
part 'city_list_res_model.g.dart';


@freezed
class CityListResModel with _$CityListResModel {
  const factory CityListResModel({
    @JsonKey(name: "status")
    int? status,
    @JsonKey(name: "data")
    Data? data,
    @JsonKey(name: "message")
    String? message,
  }) = _CityListResModel;

  factory CityListResModel.fromJson(Map<String, dynamic> json) => _$CityListResModelFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
    @JsonKey(name: "Cities")
    List<City>? cities,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
class City with _$City {
  const factory City({
    @JsonKey(name: "_id")
    String? id,
    @JsonKey(name: "cityName")
    String? cityName,
    @JsonKey(name: "createdAt")
    DateTime? createdAt,
    @JsonKey(name: "updatedAt")
    DateTime? updatedAt,
    @JsonKey(name: "__v")
    int? v,
    @JsonKey(name: "createdBy")
    String? createdBy,
    @JsonKey(name: "updatedBy")
    String? updatedBy,
  }) = _City;

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);
}
