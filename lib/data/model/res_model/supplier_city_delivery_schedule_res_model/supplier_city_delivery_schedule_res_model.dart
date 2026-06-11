class SupplierCityDeliveryScheduleResModel {
  SupplierCityDeliveryScheduleResModel({
    this.status,
    this.data,
    this.message,
  });

  final int? status;
  final SupplierCityDeliveryScheduleData? data;
  final String? message;

  factory SupplierCityDeliveryScheduleResModel.fromJson(Map<String, dynamic> json) {
    return SupplierCityDeliveryScheduleResModel(
      status: json['status'] as int?,
      data: json['data'] == null
          ? null
          : SupplierCityDeliveryScheduleData.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String?,
    );
  }
}

class SupplierCityDeliveryScheduleData {
  SupplierCityDeliveryScheduleData({
    this.cityName,
    this.deliveryDays,
  });

  final String? cityName;
  final List<SupplierCityDeliveryDay>? deliveryDays;

  factory SupplierCityDeliveryScheduleData.fromJson(Map<String, dynamic> json) {
    return SupplierCityDeliveryScheduleData(
      cityName: json['cityName'] as String?,
      deliveryDays: (json['deliveryDays'] as List<dynamic>?)
          ?.map((day) => SupplierCityDeliveryDay.fromJson(day as Map<String, dynamic>))
          .toList(),
    );
  }
}

class SupplierCityDeliveryDay {
  SupplierCityDeliveryDay({
    this.deliveryDay,
    this.orderUntilDay,
    this.deliveryUntilTime,
    this.orderUntilTime,
  });

  final int? deliveryDay;
  final int? orderUntilDay;
  final String? deliveryUntilTime;
  final String? orderUntilTime;

  factory SupplierCityDeliveryDay.fromJson(Map<String, dynamic> json) {
    return SupplierCityDeliveryDay(
      deliveryDay: json['deliveryDay'] as int?,
      orderUntilDay: json['orderUntilDay'] as int?,
      deliveryUntilTime: _readTime(json['deliveryUntilTime']),
      orderUntilTime: _readTime(json['orderUntilTime']),
    );
  }

  static String? _readTime(dynamic value) {
    if (value == null) {
      return null;
    }
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }
}
