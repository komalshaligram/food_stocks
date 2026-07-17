import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../models/invoice_item.dart';
import '../../models/resolved_item.dart';

/// משחזר ברקודים לשורות חשבונית שאין בהן ברקוד (חלק מהספקים, למשל פיליפ מוריס,
/// מדפיסים רק תיאור מוצר מקוצץ). קורא ל-Cloud Function `resolveInvoiceItems`,
/// שמצליבה מול קטלוג הלקוח לפי שם + **מחיר קניה**.
///
/// ⚠️ הפונקציה חיה בפרויקט המשני `tavilidocscan` — חובה להעביר את ה-[FirebaseApp]
/// שלו. ה-app הראשי הוא `foodstock-dev`, שם הפונקציה לא קיימת.
///
/// ההצלבה רצה בשרת ולא כאן, כי `getProducts` מחזירה קטלוג רזה **ללא `מחיר קניה`** —
/// האות החזק ביותר להתאמה.
class InvoiceItemsResolverService {
  InvoiceItemsResolverService({
    required FirebaseApp app,
    String region = 'europe-west1',
  }) : _functions = FirebaseFunctions.instanceFor(app: app, region: region);

  final FirebaseFunctions _functions;

  /// [items] — שורות החשבונית (נשלחות כפי שהן, כולל שורות שכבר יש להן ברקוד:
  /// השיבוץ הוא חד-חד-ערכי על פני כל השורות, ושורה פתורה מוציאה מועמד מהמשחק).
  /// [supplierCode] — קוד ספק החשבונית. **חיזוק ניקוד בלבד**, לא פילטר.
  Future<ResolveItemsResult> resolve({
    required List<InvoiceItem> items,
    String? customerCode,
    String? supplierCode,
  }) async {
    final callable = _functions.httpsCallable(
      'resolveInvoiceItems',
      options: HttpsCallableOptions(timeout: const Duration(seconds: 60)),
    );

    final result = await callable.call(<String, dynamic>{
      if (customerCode != null && customerCode.trim().isNotEmpty)
        'customerCode': customerCode.trim(),
      if (supplierCode != null && supplierCode.trim().isNotEmpty)
        'supplierCode': supplierCode.trim(),
      'lines': items
          .map((it) => <String, dynamic>{
                'lineNumber': it.lineNumber,
                'description': it.description,
                // המחיר ליחידה **לפני** הנחה — זה מה שמופיע בעמודת "מחיר ליח'"
                // בחשבונית, וזה מה שמושווה מול `מחיר קניה` בקטלוג.
                'unitPrice': it.pricePerUnit,
              })
          .toList(),
    });

    final data = Map<String, dynamic>.from(result.data as Map);
    final rawItems = (data['items'] as List?) ?? const [];
    return ResolveItemsResult(
      items: rawItems
          .whereType<Object?>()
          .map((e) => ResolvedItem.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      catalogDate: data['catalogDate']?.toString(),
      catalogSize: (data['catalogSize'] as num?)?.toInt() ?? 0,
    );
  }
}
