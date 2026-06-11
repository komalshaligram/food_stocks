/// First-order-from-supplier flow: dialog, client data verification navigation.
///
/// Gated by API field isFirstOrderFromSupplier (prior orders + supplierDetail.showFirstOrderMessage).
/// See docs/en/FIRST-ORDER-AND-CLIENT-VERIFICATION.md
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/model/res_model/cart_product_supplier/cart_products_supplier_res_model.dart';
import '../../data/model/res_model/setting_res_model/setting_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../routes/app_routes.dart';
import '../widget/first_supplier_order_dialog.dart';
import 'constants/app_constants.dart';
import 'constants/app_strings.dart';
import 'constants/app_urls.dart';

Future<void> navigateToVerifyClientDataScreen({
  required BuildContext context,
  required String nextRouteName,
  required Map<dynamic, dynamic> nextRouteArgs,
}) async {
  await Navigator.pushNamed(
    context,
    RouteDefine.verifyClientDataScreen.name,
    arguments: {
      AppStrings.verifyClientNextRoute: nextRouteName,
      AppStrings.verifyClientNextArgs: nextRouteArgs,
    },
  );
}

Future<String?> fetchFirstSupplierOrderMessageTemplate(BuildContext context) async {
  try {
    final res = await DioClient(context).get(path: AppUrlEndPoints.generalSettingUrl);
    final response = SettingResModel.fromJson(res);
    if (response.status == AppConstants.code_200) {
      final template = response.data?.firstSupplierOrderMessageTemplate?.trim();
      if (template != null && template.isNotEmpty) {
        return template;
      }
    }
  } catch (_) {}
  return null;
}

Future<CartProductsSupplierResModel?> fetchCartProductsBySupplier(BuildContext context) async {
  try {
    final preferences = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
    final cartId = preferences.getCartId();
    if (cartId.isEmpty) return null;

    final res = await DioClient(context).post('${AppUrlEndPoints.listingCartProductsSupplierUrl}$cartId');
    final response = CartProductsSupplierResModel.fromJson(res);
    if (response.status == AppConstants.code_200) {
      return response;
    }
  } catch (_) {}
  return null;
}

/// Shows first-order dialog when [isFirstOrderFromSupplier] is true (prior orders + supplier toggle).
Future<FirstOrderDialogResult> showFirstSupplierOrderDialogIfNeeded({
  required BuildContext context,
  required String language,
  required bool isFirstOrderFromSupplier,
  required String supplierDisplayName,
  required String? messageTemplate,
}) async {
  if (!isFirstOrderFromSupplier) return FirstOrderDialogResult.notNeeded;

  final template = messageTemplate?.trim();
  if (template == null || template.isEmpty) return FirstOrderDialogResult.notNeeded;

  if (!context.mounted) return FirstOrderDialogResult.cancelled;

  final shouldContinue = await showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (_) => FirstSupplierOrderDialog(
      messageTemplate: template,
      supplierDisplayName: supplierDisplayName,
      language: language,
    ),
  );

  if (shouldContinue == true) return FirstOrderDialogResult.confirmed;
  return FirstOrderDialogResult.cancelled;
}

enum FirstOrderDialogResult { notNeeded, cancelled, confirmed }

Future<FirstOrderDialogResult> checkAndShowFirstOrderDialogForSingleSupplier({
  required BuildContext context,
  required String language,
}) async {
  final results = await Future.wait([
    fetchCartProductsBySupplier(context),
    fetchFirstSupplierOrderMessageTemplate(context),
  ]);

  if (!context.mounted) return FirstOrderDialogResult.cancelled;

  final supplierResponse = results[0] as CartProductsSupplierResModel?;
  final messageTemplate = results[1] as String?;

  final supplierData = supplierResponse?.data?.data;
  if (supplierData == null || supplierData.isEmpty) return FirstOrderDialogResult.notNeeded;

  return showFirstSupplierOrderDialogIfNeeded(
    context: context,
    language: language,
    isFirstOrderFromSupplier: supplierData.first.isFirstOrderFromSupplier ?? false,
    supplierDisplayName: supplierData.first.suppliers?.contactName ?? '',
    messageTemplate: messageTemplate,
  );
}
