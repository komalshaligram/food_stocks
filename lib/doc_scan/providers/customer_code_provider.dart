import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_stock/data/storage/shared_preferences_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _prefsKey = 'customer_code';

/// קוד הלקוח שמולו עובדים (Comax). הקראולר מזהה לקוח לפי ה-ObjectId של הלקוח
/// אצלנו ב-FoodStock — וזה בדיוק ה-clientId של המשתמש המחובר (getUserId()).
/// נשלח ל-Cloud Functions; אם ריק — השרת נופל לברירת המחדל שב-Secret Manager.
/// הטוקן עצמו לעולם אינו באפליקציה — רק קוד הלקוח.
const String defaultCustomerCode = '66cdbace9356026ff438615f';

final customerCodeProvider =
    StateNotifierProvider<CustomerCodeNotifier, String>(
  (ref) => CustomerCodeNotifier(),
);

class CustomerCodeNotifier extends StateNotifier<String> {
  CustomerCodeNotifier() : super(defaultCustomerCode) {
    ready = _load();
  }

  /// מסתיים כשה-clientId האמיתי נקרא מ-SharedPreferences.
  ///
  /// ⚠️ עד אז [state] מחזיר את [defaultCustomerCode] — קוד של **לקוח אמיתי**.
  /// כל צרכן שמעביר את הקוד ל-Cloud Function (קטלוג, ספקים, אימות חשבונית,
  /// שליחה לקופה) **חייב** להמתין לזה, אחרת הוא עלול לפעול מול הלקוח הלא נכון.
  late final Future<void> ready;

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    // קדימות: קוד שהוגדר ידנית (override לבדיקות) → ה-clientId המחובר → ברירת מחדל.
    final saved = prefs.getString(_prefsKey);
    if (saved != null && saved.trim().isNotEmpty) {
      state = saved.trim();
      return;
    }
    final clientId = SharedPreferencesHelper(prefs: prefs).getUserId();
    if (clientId.trim().isNotEmpty) {
      state = clientId.trim();
    }
  }

  Future<void> setCode(String code) async {
    final c = code.trim();
    state = c;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, c);
  }
}
