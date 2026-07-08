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

  /// טוען את רשימת הספקים. מחזיר את הבקשה שכבר רצה (אם יש) כדי שניתן להמתין לה.
  Future<void> load({bool force = false}) {
    if (_inFlight != null) return _inFlight!;
    if (state.loaded && !force) return Future<void>.value();
    _inFlight = _doLoad();
    return _inFlight!;
  }

  Future<void> _doLoad() async {
    state = state.copyWith(loading: true, clearError: true);
    try {
      final res = await _service.fetchSuppliers(
        customerCode: _ref.read(customerCodeProvider),
      );
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
