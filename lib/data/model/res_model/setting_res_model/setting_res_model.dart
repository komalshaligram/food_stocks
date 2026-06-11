import 'package:freezed_annotation/freezed_annotation.dart';

part 'setting_res_model.freezed.dart';
part 'setting_res_model.g.dart';

@freezed
class SettingResModel with _$SettingResModel {
  const factory SettingResModel({
    Data? data,
    int? status,
    String? message,
  }) = _SettingResModel;

  factory SettingResModel.fromJson(Map<String, dynamic> json) => _$SettingResModelFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
    String? pesachBanner,
    bool? isShowPesachBanner,
    bool? isShowPesachBadge,
    double? bottlePrice,
    bool? isSaleOn,
    bool? isAppOnMaintenance,
    TaviliRivchitDetails? taviliRivchitDetails,
    List<String>? showVatApplication,
    DataWebViewSettings? dataWebViewSettings,
    RegistrationSuccessPageSettings? registrationSuccessPageSettings,
    String? firstSupplierOrderMessageTemplate,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
class TaviliRivchitDetails with _$TaviliRivchitDetails {
  const factory TaviliRivchitDetails({
    String? bankTransferInfoText,
  }) = _TaviliRivchitDetails;

  factory TaviliRivchitDetails.fromJson(Map<String, dynamic> json) => _$TaviliRivchitDetailsFromJson(json);
}

@freezed
class DataWebViewSettings with _$DataWebViewSettings {
  const factory DataWebViewSettings({
    String? baseUrl,
    String? buttonEnglishText,
    String? screenEnglishTitle,
    String? buttonHebrewText,
    String? screenHebrewTitle,
  }) = _DataWebViewSettings;

  factory DataWebViewSettings.fromJson(Map<String, dynamic> json) => _$DataWebViewSettingsFromJson(json);
}

@freezed
class RegistrationSuccessPageSettings with _$RegistrationSuccessPageSettings {
  const factory RegistrationSuccessPageSettings({
    bool? showRegistrationSuccessPage,
    String? registrationSuccessPageText,
  }) = _RegistrationSuccessPageSettings;

  factory RegistrationSuccessPageSettings.fromJson(Map<String, dynamic> json) => _$RegistrationSuccessPageSettingsFromJson(json);
}
