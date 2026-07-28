import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../bootstrap/doc_scan_bootstrap.dart';
import '../core/services/item_form_options_service.dart';
import '../models/item_form_options.dart';
import 'customer_code_provider.dart';

/// מצב טעינת רשימות הבחירה של טופס "פריט חדש". נטען בעצלתיים בפתיחת הטופס.
class ItemFormOptionsState {
  const ItemFormOptionsState({
    this.options = const ItemFormOptions(),
    this.loading = false,
    this.loaded = false,
    this.error,
  });

  final ItemFormOptions options;
  final bool loading;
  final bool loaded;

  /// `no_data` = עדיין לא בוצעה שליפה ללקוח הזה — מובחן משגיאה אמיתית כדי שהטופס
  /// יוכל להציג הודעה מדויקת במקום "התרחשה שגיאה".
  final String? error;

  bool get isNoData => error != null && error!.contains('no_data');

  ItemFormOptionsState copyWith({
    ItemFormOptions? options,
    bool? loading,
    bool? loaded,
    String? error,
    bool clearError = false,
  }) {
    return ItemFormOptionsState(
      options: options ?? this.options,
      loading: loading ?? this.loading,
      loaded: loaded ?? this.loaded,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class ItemFormOptionsNotifier extends StateNotifier<ItemFormOptionsState> {
  ItemFormOptionsNotifier(this._service, this._ref)
      : super(const ItemFormOptionsState());

  final ItemFormOptionsService _service;
  final Ref _ref;
  Future<void>? _inFlight;

  /// קוד הלקוח שעבורו נטענו הרשימות הנוכחיות. ⚠️ קריטי: הקודים הם פר-לקוח
  /// ומתנגשים (קוד 7 = גרם/קרטון/ק״ג לפי הלקוח), ולכן החלפת לקוח **חייבת** לגרור
  /// שליפה מחדש — רשימה של לקוח אחד תפתח פריט ביחידת מידה שגויה אצל השני.
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
      final res = await _service.fetchItemFormOptions(customerCode: customerCode);
      _loadedCustomerCode = customerCode;
      state = ItemFormOptionsState(options: res, loading: false, loaded: true);
    } catch (e) {
      // הרשימות הישנות נזרקות: עדיף טופס בלי דרופדאונים מאשר דרופדאונים של לקוח אחר.
      _loadedCustomerCode = null;
      state = ItemFormOptionsState(loading: false, error: e.toString());
    } finally {
      _inFlight = null;
    }
  }
}

final itemFormOptionsServiceProvider = Provider<ItemFormOptionsService>(
  (ref) => ItemFormOptionsService(app: DocScanBootstrap.firebaseApp),
);

final itemFormOptionsProvider =
    StateNotifierProvider<ItemFormOptionsNotifier, ItemFormOptionsState>(
  (ref) => ItemFormOptionsNotifier(ref.read(itemFormOptionsServiceProvider), ref),
);
