import 'package:flutter/material.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/constants/app_constants.dart';
import '../../ui/utils/constants/app_urls.dart';
import '../model/res_model/supplier_city_delivery_schedule_res_model/supplier_city_delivery_schedule_res_model.dart';

class SupplierDeliveryScheduleService {
  SupplierDeliveryScheduleService._();

  static Future<Map<String, SupplierCityDeliveryScheduleData>> loadForSuppliers(
      {required BuildContext context, required Iterable<String> supplierIds}) async {
    final ids = supplierIds.where((id) => id.trim().isNotEmpty).toSet().toList();
    if (ids.isEmpty) {
      return {};
    }
    final entries = await Future.wait(ids.map((id) => _loadOne(context: context, supplierId: id)));
    return {
      for (final entry in entries)
        if (entry != null) entry.key: entry.value
    };
  }

  static Future<MapEntry<String, SupplierCityDeliveryScheduleData>?> _loadOne({required BuildContext context, required String supplierId}) async {
    try {
      final res = await DioClient(context).get(path: '${AppUrlEndPoints.getSupplierCityDeliveryScheduleUrl}$supplierId');
      final response = SupplierCityDeliveryScheduleResModel.fromJson(res);
      final data = response.data;
      if (response.status == AppConstants.code_200 && data != null) {
        return MapEntry(supplierId, data);
      }
    } catch (_) {}
    return null;
  }
}