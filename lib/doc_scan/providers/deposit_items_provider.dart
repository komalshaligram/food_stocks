import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../bootstrap/doc_scan_bootstrap.dart';

import '../core/services/deposit_items_service.dart';
import '../models/deposit_option.dart';
import 'customer_code_provider.dart';

/// מצב רשימות הפיקדון לטופס "פריט חדש" (נטען בעצלתיים, נשמר ב-cache לסשן).
class DepositItemsState {
  const DepositItemsState({
    this.misc = const [],
    this.draggedToRegister = const [],
    this.depositItem = const [],
    this.loading = false,
    this.loaded = false,
    this.error,
  });

  final List<DepositOption> misc;
  final List<DepositOption> draggedToRegister;
  final List<DepositOption> depositItem;
  final bool loading;
  final bool loaded;
  final String? error;
}

class DepositItemsNotifier extends StateNotifier<DepositItemsState> {
  DepositItemsNotifier(this._service, this._ref)
      : super(const DepositItemsState());

  final DepositItemsService _service;
  final Ref _ref;

  /// קוד הלקוח שעבורו נטענו הנתונים הנוכחיים. `customerCodeProvider` מתחיל בקוד
  /// ברירת מחדל וקורא את ה-clientId האמיתי אסינכרונית — בלי המעקב הזה, הקריאה
  /// הראשונה נועלת את הנתונים של לקוח ברירת המחדל לכל הסשן.
  String? _loadedCustomerCode;

  Future<void> load({bool force = false}) async {
    if (state.loading) return;
    await _ref.read(customerCodeProvider.notifier).ready;
    final customerCode = _ref.read(customerCodeProvider);
    if (state.loaded && !force && _loadedCustomerCode == customerCode) return;
    state = const DepositItemsState(loading: true);
    try {
      final res = await _service.fetchDepositItems(customerCode: customerCode);
      _loadedCustomerCode = customerCode;
      state = DepositItemsState(
        misc: res.misc,
        draggedToRegister: res.draggedToRegister,
        depositItem: res.depositItem,
        loaded: true,
      );
    } catch (e) {
      state = DepositItemsState(error: e.toString());
    }
  }
}

final depositItemsServiceProvider =
    Provider<DepositItemsService>((ref) => DepositItemsService(app: DocScanBootstrap.firebaseApp));

final depositItemsProvider =
    StateNotifierProvider<DepositItemsNotifier, DepositItemsState>(
  (ref) => DepositItemsNotifier(ref.read(depositItemsServiceProvider), ref),
);
