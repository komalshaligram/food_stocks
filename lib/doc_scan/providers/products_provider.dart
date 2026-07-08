import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../bootstrap/doc_scan_bootstrap.dart';

import '../core/services/products_service.dart';
import '../models/product.dart';
import 'customer_code_provider.dart';
import 'suppliers_provider.dart' show normalizeHebrewForSearch;

/// נרמול ברקוד/קוד להשוואה: גזירה והסרת רווחים (הברקודים מספריים).
String _normCode(String input) => input.replaceAll(RegExp(r'\s+'), '').trim();

/// צורה קנונית של ברקוד להתאמה "סלחנית" — חשבוניות מציגות לרוב ברקוד מקוצר בעוד
/// הקטלוג מחזיק EAN-13 מלא. מסירה תווים לא-ספרתיים, את קידומת ה-GS1 הישראלית `729`
/// (כשזה EAN-13 שמתחיל ב-729), ואפסים מובילים. כך `7290003643684` ו-`3643684`
/// מקבלים אותו מפתח (`3643684`). מחזיר '' אם קצר מדי מכדי להתאים בבטחה.
String _canonicalBarcode(String input) {
  var s = input.replaceAll(RegExp(r'[^0-9]'), '');
  if (s.isEmpty) return '';
  if (s.length == 13 && s.startsWith('729')) {
    s = s.substring(3);
  }
  s = s.replaceFirst(RegExp(r'^0+'), '');
  // מתחת ל-5 ספרות — סיכון להתאמות שווא; לא משתמשים בצורה הקנונית.
  return s.length >= 5 ? s : '';
}

/// מצב טעינת קטלוג המוצרים (נטען פעם אחת בפתיחת האפליקציה ונשמר ב-cache).
/// בונה אינדקס ברקוד+קוד לזיהוי מהיר של פריטים מהסריקה.
class ProductsState {
  ProductsState({
    this.products = const [],
    this.loading = false,
    this.loaded = false,
    this.error,
    this.customerName,
    this.date,
  })  : _byBarcode = _buildBarcodeIndex(products),
        _byCanonical = _buildCanonicalIndex(products),
        _codes = _buildCodeIndex(products);

  final List<Product> products;
  final bool loading;
  final bool loaded;
  final String? error;
  final String? customerName;
  final String? date;

  /// ברקוד מנורמל → מוצר (התאמה מדויקת).
  final Map<String, Product> _byBarcode;

  /// ברקוד בצורה קנונית → מוצר (התאמה סלחנית: 729/אפסים מובילים).
  final Map<String, Product> _byCanonical;

  /// קודי מוצר מנורמלים (fallback כשבמסמך הופיע קוד ולא ברקוד).
  final Set<String> _codes;

  static Map<String, Product> _buildBarcodeIndex(List<Product> products) {
    final map = <String, Product>{};
    for (final p in products) {
      final key = _normCode(p.barcode);
      if (key.isNotEmpty) map[key] = p;
    }
    return map;
  }

  static Map<String, Product> _buildCanonicalIndex(List<Product> products) {
    final map = <String, Product>{};
    for (final p in products) {
      final key = _canonicalBarcode(p.barcode);
      if (key.isNotEmpty) map.putIfAbsent(key, () => p);
    }
    return map;
  }

  static Set<String> _buildCodeIndex(List<Product> products) {
    final set = <String>{};
    for (final p in products) {
      final key = _normCode(p.code);
      if (key.isNotEmpty) set.add(key);
    }
    return set;
  }

  /// האם הקטלוג נטען ויש בו מוצרים (תנאי לסימון "לא קיים").
  bool get hasCatalog => loaded && products.isNotEmpty;

  /// התאמת ברקוד/קוד למוצר בקטלוג: מדויק → קוד פריט → צורה קנונית (729/אפסים).
  Product? _matchProduct(String? itemNumber) {
    final key = _normCode(itemNumber ?? '');
    if (key.isEmpty) return null;
    final exact = _byBarcode[key];
    if (exact != null) return exact;
    final canon = _canonicalBarcode(itemNumber ?? '');
    if (canon.isNotEmpty) {
      final c = _byCanonical[canon];
      if (c != null) return c;
    }
    return null;
  }

  /// האם מספר הפריט (ברקוד או קוד) קיים בקטלוג. ריק → נחשב "ידוע" (אין מה לסמן).
  bool isKnownItemNumber(String? itemNumber) {
    final key = _normCode(itemNumber ?? '');
    if (key.isEmpty) return true;
    if (_byBarcode.containsKey(key) || _codes.contains(key)) return true;
    return _matchProduct(itemNumber) != null;
  }

  /// המוצר התואם לברקוד (אם קיים), לצורך הצגת שמו.
  Product? productForBarcode(String? itemNumber) => _matchProduct(itemNumber);

  /// חיפוש מוצרים לפי שם (עברית-סלחני, כמו ה-search של ה-API), עד [limit] תוצאות.
  /// [supplierName] — אם נשלח, מסנן רק מוצרים של אותו ספק (לפי שם, התאמה דו-כיוונית
  /// כדי לגשר על קיצור שם הספק בקטלוג).
  /// כל מוצרי ספק נתון (לפי שם, התאמה דו-כיוונית כמו ב-searchByName).
  /// בלי שם ספק — כל הקטלוג. משמש לבורר החיפוש הנגלל בעורך הברקוד (§9).
  List<Product> productsForSupplier(String? supplierName) {
    final supplierKey = normalizeHebrewForSearch(supplierName ?? '');
    if (supplierKey.isEmpty) return products;
    return products.where((p) {
      final ps = normalizeHebrewForSearch(p.supplier);
      if (ps.isEmpty) return false;
      return ps == supplierKey ||
          ps.contains(supplierKey) ||
          supplierKey.contains(ps);
    }).toList(growable: false);
  }

  List<Product> searchByName(String query, {int limit = 40, String? supplierName}) {
    final q = normalizeHebrewForSearch(query);
    if (q.isEmpty) return const [];
    final words = q.split(' ').where((w) => w.isNotEmpty).toList();
    final supplierKey = normalizeHebrewForSearch(supplierName ?? '');
    final out = <Product>[];
    for (final p in products) {
      if (supplierKey.isNotEmpty) {
        final ps = normalizeHebrewForSearch(p.supplier);
        if (ps.isEmpty) continue;
        final sameSupplier =
            ps == supplierKey || ps.contains(supplierKey) || supplierKey.contains(ps);
        if (!sameSupplier) continue;
      }
      final name = normalizeHebrewForSearch(p.name);
      final barcode = p.barcode.toLowerCase();
      final code = p.code.toLowerCase();
      final matches = words.every(
        (w) => name.contains(w) || barcode.contains(w) || code.contains(w),
      );
      if (matches) {
        out.add(p);
        if (out.length >= limit) break;
      }
    }
    return out;
  }

  ProductsState copyWith({
    List<Product>? products,
    bool? loading,
    bool? loaded,
    String? error,
    bool clearError = false,
    String? customerName,
    String? date,
  }) {
    return ProductsState(
      products: products ?? this.products,
      loading: loading ?? this.loading,
      loaded: loaded ?? this.loaded,
      error: clearError ? null : (error ?? this.error),
      customerName: customerName ?? this.customerName,
      date: date ?? this.date,
    );
  }
}

class ProductsNotifier extends StateNotifier<ProductsState> {
  ProductsNotifier(this._service, this._ref) : super(ProductsState());

  final ProductsService _service;
  final Ref _ref;

  /// טוען את הקטלוג. אם כבר נטען — לא טוען שוב אלא אם [force].
  Future<void> load({bool force = false}) async {
    if (state.loading) return;
    if (state.loaded && !force) return;
    state = state.copyWith(loading: true, clearError: true);
    try {
      final res = await _service.fetchProducts(
        customerCode: _ref.read(customerCodeProvider),
      );
      state = ProductsState(
        products: res.products,
        loading: false,
        loaded: true,
        customerName: res.customerName,
        date: res.date,
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }
}

final productsServiceProvider =
    Provider<ProductsService>((ref) => ProductsService(app: DocScanBootstrap.firebaseApp));

final productsProvider =
    StateNotifierProvider<ProductsNotifier, ProductsState>(
  (ref) => ProductsNotifier(ref.read(productsServiceProvider), ref),
);
