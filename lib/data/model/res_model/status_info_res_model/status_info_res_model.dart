import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'status_info_res_model.freezed.dart';
part 'status_info_res_model.g.dart';

StatusInfoResModel statusInfoResModelFromJson(String str) => StatusInfoResModel.fromJson(json.decode(str));

String statusInfoResModelToJson(StatusInfoResModel data) => json.encode(data.toJson());

@freezed
class StatusInfoResModel with _$StatusInfoResModel {
  const factory StatusInfoResModel({
    @JsonKey(name: "status") int? status,
    @JsonKey(name: "data") Data? data,
    @JsonKey(name: "message") String? message,
  }) = _StatusInfoResModel;

  factory StatusInfoResModel.fromJson(Map<String, dynamic> json) => _$StatusInfoResModelFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
    @JsonKey(name: "status") List<StatusData>? status,
    @JsonKey(name: "orderStatus") List<StatusData>? orderStatus,
    @JsonKey(name: "paymentStatus") List<StatusData>? paymentStatus,
    @JsonKey(name: "returnStatus") List<StatusData>? returnStatus,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
class StatusData with _$StatusData {
  const factory StatusData({
    @JsonKey(name: "statusNameKey") String? statusNameKey,
    @JsonKey(name: "statusNameEnglish") String? statusNameEnglish,
    @JsonKey(name: "statusNameHebrew") String? statusNameHebrew,
    @JsonKey(name: "statusColor") String? statusColor,
    @JsonKey(name: "statusId") int? statusId,
  }) = _Status;

  factory StatusData.fromJson(Map<String, dynamic> json) => _$StatusDataFromJson(json);

  static Map<String, dynamic> toMap(StatusData status) => {
        'statusNameKey': status.statusNameKey,
        'statusColor': status.statusColor,
        'statusId': status.statusId,
        'statusNameEnglish': status.statusNameEnglish,
        'statusNameHebrew': status.statusNameHebrew,
      };

  static String encode(List<StatusData> musics) => json.encode(
        musics.map<Map<String, dynamic>>((music) => StatusData.toMap(music)).toList(),
      );

  static List<StatusData> decode(String musics) => (json.decode(musics) as List<dynamic>).map<StatusData>((item) => StatusData.fromJson(item)).toList();
}
