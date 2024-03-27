
import 'package:freezed_annotation/freezed_annotation.dart';


part 'setting_res_model.freezed.dart';
part 'setting_res_model.g.dart';

@freezed
class SettingResModel with _$SettingResModel {
  const factory SettingResModel({
    required Data data,
    required int status,
    required String message,
  }) = _SettingResModel;

  factory SettingResModel.fromJson(Map<String, dynamic> json) => _$SettingResModelFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
    required String pesachBanner,
    required bool isShowPesachBanner,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}
