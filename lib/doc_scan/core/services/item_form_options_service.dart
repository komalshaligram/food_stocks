import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../models/item_form_options.dart';

/// טוען את שמונה רשימות הבחירה של טופס "פריט חדש" בקריאה אחת, דרך ה-Cloud Function
/// `getItemFormOptions` (proxy ל-`GET /api/v1/item-form-options`).
///
/// מחליף את `DepositItemsService` לצורכי הטופס: אותן 3 רשימות פקדון, ועוד 5,
/// והכי חשוב — עם הדגל `present` לכל רשימה. `getDepositItems` נשאר לתאימות לאחור.
class ItemFormOptionsService {
  ItemFormOptionsService({
    required FirebaseApp app,
    String region = 'europe-west1',
  }) : _functions = FirebaseFunctions.instanceFor(app: app, region: region);

  final FirebaseFunctions _functions;

  Future<ItemFormOptions> fetchItemFormOptions({String? customerCode}) async {
    final callable = _functions.httpsCallable(
      'getItemFormOptions',
      options: HttpsCallableOptions(timeout: const Duration(seconds: 30)),
    );
    final result = await callable.call(<String, dynamic>{
      if (customerCode != null && customerCode.trim().isNotEmpty)
        'customerCode': customerCode.trim(),
    });
    return ItemFormOptions.fromJson(Map<String, dynamic>.from(result.data as Map));
  }
}
