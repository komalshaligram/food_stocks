import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../bootstrap/doc_scan_bootstrap.dart';
import '../core/services/suppliers_service.dart';
import '../models/supplier.dart';
import 'customer_code_provider.dart';

/// מצב טעינת רשימת הספקים (נטענת פעם אחת בפתיחת האפליקציה ונשמרת ב-cache).
class SuppliersState {
  const SuppliersState({
    this.suppliers = const [],
    this.loading = false,
    this.loaded = false,
    this.error,
    this.customerName,
    this.date,
  });

  final List<Supplier> suppliers;

  /// **כל** קודי הספק שנושאים את הח.פ הזה.
  ///
  /// לא בהכרח אחד: ב-644 הספקים של לקוח אחד, 12 ח.פ מופיעים ביותר מרשומה אחת
  /// (שופרסל, למשל, מופיע בשלוש — רשת, "עסקים", וסיטונאות). בחירת הראשון הייתה
  /// שרירותית ועלולה לבדוק כפילות מול הספק הלא נכון.
  ///
  /// ההשוואה על ספרות בלבד: ה-OCR מוסיף לפעמים רווחים או מקפים.
  List<String> codesForTaxId(String taxId) {
    final key = taxId.replaceAll(RegExp(r'[^0-9]'), '');
    if (key.isEmpty) return const [];
    return suppliers
        .where((s) => s.taxId.replaceAll(RegExp(r'[^0-9]'), '') == key)
        .map((s) => s.code)
        .where((c) => c.isNotEmpty)
        .toList(growable: false);
  }

  /// קוד הספק ששמו תואם (נורמליזציה עברית), או '' אם אין התאמה/יש עמימות
  /// (יותר מקוד אחד). משמש לגזירת קוד הספק מ-`companyName` שנבחר בזמן הסריקה,
  /// כדי שה-toggle "רק ספק זה" יופיע ישר בלי לבחור ספק שוב במסך הפרטים. חשוב
  /// לספקים ללא ח.פ בקומקס (כמו רגבים) שבהם `codesForTaxId` מחזיר ריק.
  String codeForName(String name) {
    final key = normalizeHebrewForSearch(name);
    if (key.isEmpty) return '';
    final matches = suppliers
        .where((s) => normalizeHebrewForSearch(s.name) == key)
        .map((s) => s.code)
        .where((c) => c.isNotEmpty)
        .toSet();
    return matches.length == 1 ? matches.first : '';
  }

  final bool loading;
  final bool loaded;
  final String? error;
  final String? customerName;
  final String? date;

  SuppliersState copyWith({
    List<Supplier>? suppliers,
    bool? loading,
    bool? loaded,
    String? error,
    bool clearError = false,
    String? customerName,
    String? date,
  }) {
    return SuppliersState(
      suppliers: suppliers ?? this.suppliers,
      loading: loading ?? this.loading,
      loaded: loaded ?? this.loaded,
      error: clearError ? null : (error ?? this.error),
      customerName: customerName ?? this.customerName,
      date: date ?? this.date,
    );
  }
}

class SuppliersNotifier extends StateNotifier<SuppliersState> {
  SuppliersNotifier(this._service, this._ref) : super(const SuppliersState()) {
    load();
  }

  final SuppliersService _service;
  final Ref _ref;
  Future<void>? _inFlight;

  /// קוד הלקוח שעבורו נטענו הנתונים הנוכחיים. `customerCodeProvider` מתחיל בקוד
  /// ברירת מחדל וקורא את ה-clientId האמיתי אסינכרונית — בלי המעקב הזה, הקריאה
  /// הראשונה נועלת את הנתונים של לקוח ברירת המחדל לכל הסשן.
  String? _loadedCustomerCode;


  /// טוען את רשימת הספקים. מחזיר את הבקשה שכבר רצה (אם יש) כדי שניתן להמתין לה.
  Future<void> load({bool force = false}) {
    if (_inFlight != null) return _inFlight!;
    _inFlight = _doLoad(force: force);
    return _inFlight!;
  }

  Future<void> _doLoad({bool force = false}) async {
    await _ref.read(customerCodeProvider.notifier).ready;
    final customerCode = _ref.read(customerCodeProvider);
    if (state.loaded && !force && _loadedCustomerCode == customerCode) return;
    state = state.copyWith(loading: true, clearError: true);
    try {
      final res = await _service.fetchSuppliers(customerCode: customerCode);
      _loadedCustomerCode = customerCode;
      state = SuppliersState(
        suppliers: res.suppliers,
        loading: false,
        loaded: true,
        customerName: res.customerName,
        date: res.date,
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    } finally {
      _inFlight = null;
    }
  }
}

final suppliersServiceProvider = Provider<SuppliersService>(
  (ref) => SuppliersService(app: DocScanBootstrap.firebaseApp),
);

final suppliersProvider =
    StateNotifierProvider<SuppliersNotifier, SuppliersState>(
  (ref) => SuppliersNotifier(ref.read(suppliersServiceProvider), ref),
);

/// נרמול עברי לחיפוש סלחני — תואם את ה-smart search של ה-API:
/// הסרת ניקוד/גרשיים, איחוד אותיות סופיות, lowercase, איחוד רווחים.
String normalizeHebrewForSearch(String input) {
  var t = input.toLowerCase();
  // ניקוד וטעמים
  t = t.replaceAll(RegExp(r'[֑-ׇ]'), '');
  // גרש/גרשיים/מרכאות
  t = t.replaceAll(RegExp('[\'"`‘’“”׳״]'), '');
  // אותיות סופיות → רגילות
  const finals = {
    'ם': 'מ', // ם → מ
    'ן': 'נ', // ן → נ
    'ך': 'כ', // ך → כ
    'ף': 'פ', // ף → פ
    'ץ': 'צ', // ץ → צ
  };
  final sb = StringBuffer();
  for (final ch in t.split('')) {
    sb.write(finals[ch] ?? ch);
  }
  return sb.toString().replaceAll(RegExp(r'\s+'), ' ').trim();
}

/// סינון ספקים מקומי (תואם ל-search של ה-API): כל המילים חייבות להופיע (AND),
/// בכל סדר, התאמה חלקית, וגם חיפוש לפי קוד ספק.
List<Supplier> filterSuppliers(List<Supplier> all, String query) {
  final q = normalizeHebrewForSearch(query);
  if (q.isEmpty) return all;
  final words = q.split(' ').where((w) => w.isNotEmpty).toList();
  return all.where((s) {
    final name = normalizeHebrewForSearch(s.name);
    final code = s.code.toLowerCase();
    return words.every((w) => name.contains(w) || code.contains(w));
  }).toList(growable: false);
}
