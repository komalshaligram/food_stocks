import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../bootstrap/doc_scan_bootstrap.dart';

import '../core/services/catalog_taxonomy_service.dart';
import '../models/catalog_taxonomy.dart';
import 'customer_code_provider.dart';

/// מצב טעינת מחלקות+קבוצות הקטלוג (לטופס "צור פריט חדש"). נטען בעצלתיים בפעם הראשונה.
class CatalogTaxonomyState {
  const CatalogTaxonomyState({
    this.departments = const [],
    this.groups = const [],
    this.loading = false,
    this.loaded = false,
    this.error,
  });

  final List<CatalogDepartment> departments;
  final List<CatalogGroup> groups;
  final bool loading;
  final bool loaded;
  final String? error;

  /// הקבוצות של מחלקה נתונה (לפי קוד מחלקה).
  List<CatalogGroup> groupsForDepartment(String departmentCode) => groups
      .where((g) => g.departmentCode == departmentCode)
      .toList(growable: false);

  CatalogTaxonomyState copyWith({
    List<CatalogDepartment>? departments,
    List<CatalogGroup>? groups,
    bool? loading,
    bool? loaded,
    String? error,
    bool clearError = false,
  }) {
    return CatalogTaxonomyState(
      departments: departments ?? this.departments,
      groups: groups ?? this.groups,
      loading: loading ?? this.loading,
      loaded: loaded ?? this.loaded,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class CatalogTaxonomyNotifier extends StateNotifier<CatalogTaxonomyState> {
  CatalogTaxonomyNotifier(this._service, this._ref)
      : super(const CatalogTaxonomyState());

  final CatalogTaxonomyService _service;
  final Ref _ref;
  Future<void>? _inFlight;

  /// קוד הלקוח שעבורו נטענו הנתונים הנוכחיים. `customerCodeProvider` מתחיל בקוד
  /// ברירת מחדל וקורא את ה-clientId האמיתי אסינכרונית — בלי המעקב הזה, הקריאה
  /// הראשונה נועלת את הנתונים של לקוח ברירת המחדל לכל הסשן.
  String? _loadedCustomerCode;


  /// מחזיר את הבקשה שכבר רצה (אם יש) כדי שניתן להמתין לה גם בקריאה חוזרת.
  Future<void> load({bool force = false}) {
    if (_inFlight != null) return _inFlight!;
    _inFlight = _doLoad(force: force);
    return _inFlight!;
  }

  Future<void> _doLoad({bool force = false}) async {
    await _ref.read(customerCodeProvider.notifier).ready;
    if (state.loaded && !force &&
        _loadedCustomerCode == _ref.read(customerCodeProvider)) {
      return;
    }
    state = state.copyWith(loading: true, clearError: true);
    try {
      final customerCode = _ref.read(customerCodeProvider);
      final res = await _service.fetchTaxonomy(customerCode: customerCode);
      // בלי ההצבה הזו התנאי למעלה לעולם אינו מתקיים (null != code) והרשימות
      // נמשכות מחדש בכל פתיחה של הטופס.
      _loadedCustomerCode = customerCode;
      state = CatalogTaxonomyState(
        departments: res.departments,
        groups: res.groups,
        loading: false,
        loaded: true,
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    } finally {
      _inFlight = null;
    }
  }
}

final catalogTaxonomyServiceProvider =
    Provider<CatalogTaxonomyService>((ref) => CatalogTaxonomyService(app: DocScanBootstrap.firebaseApp));

final catalogTaxonomyProvider =
    StateNotifierProvider<CatalogTaxonomyNotifier, CatalogTaxonomyState>(
  (ref) => CatalogTaxonomyNotifier(ref.read(catalogTaxonomyServiceProvider), ref),
);
