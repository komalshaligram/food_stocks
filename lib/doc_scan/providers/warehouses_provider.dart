import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../bootstrap/doc_scan_bootstrap.dart';
import '../core/services/warehouses_service.dart';
import '../models/warehouse.dart';
import 'customer_code_provider.dart';

/// מצב טעינת רשימת מחסני היעד (§5c). נטענת פעם אחת ונשמרת ב-cache, כמו הספקים.
/// המשתמש בוחר מחסן במסך פרטי המסמך; הקוד+השם נשלחים ב-header בקליטה ל-Comax.
class WarehousesState {
  const WarehousesState({
    this.warehouses = const [],
    this.loading = false,
    this.loaded = false,
    this.error,
    this.customerName,
    this.date,
  });

  final List<Warehouse> warehouses;
  final bool loading;
  final bool loaded;
  final String? error;
  final String? customerName;
  final String? date;

  /// מחסן ברירת המחדל = הראשון ברשימה (כפי שהקרולר מחזיר). null אם ריק.
  Warehouse? get defaultWarehouse =>
      warehouses.isEmpty ? null : warehouses.first;

  /// המחסן בעל ה-[code] הנתון, או null אם אינו ברשימה.
  Warehouse? byCode(String? code) {
    final key = (code ?? '').trim();
    if (key.isEmpty) return null;
    for (final w in warehouses) {
      if (w.code == key) return w;
    }
    return null;
  }

  WarehousesState copyWith({
    List<Warehouse>? warehouses,
    bool? loading,
    bool? loaded,
    String? error,
    bool clearError = false,
    String? customerName,
    String? date,
  }) {
    return WarehousesState(
      warehouses: warehouses ?? this.warehouses,
      loading: loading ?? this.loading,
      loaded: loaded ?? this.loaded,
      error: clearError ? null : (error ?? this.error),
      customerName: customerName ?? this.customerName,
      date: date ?? this.date,
    );
  }
}

class WarehousesNotifier extends StateNotifier<WarehousesState> {
  WarehousesNotifier(this._service, this._ref)
      : super(const WarehousesState()) {
    load();
  }

  final WarehousesService _service;
  final Ref _ref;
  Future<void>? _inFlight;

  /// קוד הלקוח שעבורו נטענו הנתונים — ראו suppliers_provider (customerCodeProvider
  /// מתחיל בברירת מחדל וקורא את ה-clientId אסינכרונית).
  String? _loadedCustomerCode;

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
      final res = await _service.fetchWarehouses(customerCode: customerCode);
      _loadedCustomerCode = customerCode;
      state = WarehousesState(
        warehouses: res.warehouses,
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

final warehousesServiceProvider = Provider<WarehousesService>(
  (ref) => WarehousesService(app: DocScanBootstrap.firebaseApp),
);

final warehousesProvider =
    StateNotifierProvider<WarehousesNotifier, WarehousesState>(
  (ref) => WarehousesNotifier(ref.read(warehousesServiceProvider), ref),
);
