import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart'
    show ScanMode;
import 'package:food_stock/ui/utils/app_utils.dart' show scanBarcodeOrQRCode;

import '../core/constants/app_constants.dart';
import '../core/theme/app_colors.dart';
import '../gen_l10n/app_localizations.dart';
import '../models/catalog_taxonomy.dart';
import '../models/item_form_options.dart';
import '../models/new_product_draft.dart';
import '../models/supplier.dart';
import '../providers/catalog_taxonomy_provider.dart';
import '../providers/item_form_options_provider.dart';
import '../providers/suppliers_provider.dart';
import '../widgets/gradient_button.dart';
import '../widgets/searchable_picker.dart';

/// טופס "צור / ערוך פריט חדש" — מסך מלא, מחזיר [NewProductDraft] ב-pop בשמירה.
///
/// נפתח מגיליון עריכת הברקוד כשהברקוד של השורה אינו קיים בקטלוג הלקוח.
/// הטיוטה נשמרת על השורה ונשלחת בתוך אותה שורה ב-`lines` של `/documents/validate`.
///
/// **מבנה: 6 אזורים.** 26 שדות זה יותר מדי לרשימה שטוחה, ורק 6 מהם חובה — כולם
/// באזורים 1–2, כדי שמשתמש שממהר יסיים מהר. אזורים 1–3 פתוחים כברירת מחדל,
/// 4–6 מקופלים (רובם נשארים ריקים ברוב הפריטים).
///
/// **אזור 6 נעלם לגמרי** אם שלושת השדות שלו מוחזרים כ-`present:false` — ללקוח הזה
/// אין אותם בטופס של Comax בכלל (ראו [ItemFormOptions]).
class NewProductFormScreen extends ConsumerStatefulWidget {
  const NewProductFormScreen({
    super.key,
    this.initialDraft,
    required this.defaultBarcode,
    required this.defaultName,
    this.defaultSupplierCode,
    this.defaultSupplierName,
    this.defaultSupplierPrice,
  });

  /// טיוטה קיימת (מצב עריכה), או null ליצירה חדשה.
  final NewProductDraft? initialDraft;

  /// מילוי אוטומטי מהשורה הסרוקה.
  final String defaultBarcode;
  final String defaultName;
  final String? defaultSupplierCode;
  final String? defaultSupplierName;
  final double? defaultSupplierPrice;

  @override
  ConsumerState<NewProductFormScreen> createState() =>
      _NewProductFormScreenState();
}

class _NewProductFormScreenState extends ConsumerState<NewProductFormScreen> {
  // --- אזור 1 ---
  late final TextEditingController _itemCode;
  late final TextEditingController _barcode;
  late final TextEditingController _name;
  String? _unitCode, _unitName;
  bool _weighable = false;

  // --- אזור 2 ---
  String? _departmentCode, _departmentName;
  String? _groupCode, _groupName;
  String? _supplierCode, _supplierName;
  late final TextEditingController _supplierItem;

  // --- אזור 3 ---
  late final TextEditingController _supplierPrice;
  late final TextEditingController _discountPct;
  late final TextEditingController _profitPct;
  bool _noSupplierDiscount = false;

  // --- אזור 4 ---
  late final TextEditingController _conversionQty;
  String? _conversionUnitCode, _conversionUnitName;
  late final TextEditingController _packageWeight;
  late final TextEditingController _calcQty;

  // --- אזור 5 ---
  bool _manageDeposit = false;
  String? _draggedToRegister, _depositItem, _misc;
  bool _delicatessen = false;

  // --- אזור 6 ---
  String? _clubCode, _registerDiscount, _promotion;

  /// אזורים 4–6 מקופלים כברירת מחדל.
  final Set<int> _expanded = {1, 2, 3};

  /// ולידציה מוצגת רק אחרי ניסיון שמירה ראשון, כדי לא לצבוע טופס ריק באדום.
  bool _showErrors = false;

  @override
  void initState() {
    super.initState();
    final d = widget.initialDraft;

    _itemCode = TextEditingController(text: d?.itemCode ?? widget.defaultBarcode);
    _barcode = TextEditingController(text: d?.barcode ?? widget.defaultBarcode);
    _name = TextEditingController(text: d?.name ?? widget.defaultName);
    _supplierItem = TextEditingController(text: d?.supplierItem ?? '');
    _supplierPrice = TextEditingController(
        text: _fmt(d?.supplierPrice ?? widget.defaultSupplierPrice));
    _discountPct = TextEditingController(text: _fmt(d?.discountPct));
    _profitPct = TextEditingController(text: _fmt(d?.profitPct));
    _conversionQty = TextEditingController(text: _fmt(d?.conversionQty));
    _packageWeight = TextEditingController(text: _fmt(d?.packageWeight));
    _calcQty = TextEditingController(text: _fmt(d?.calcQty));

    _unitCode = d?.unitCode;
    _unitName = d?.unitName;
    _weighable = d?.weighable ?? false;
    _departmentCode = d?.departmentCode;
    _departmentName = d?.departmentName;
    _groupCode = d?.groupCode;
    _groupName = d?.groupName;
    _supplierCode = d?.supplierCode ?? widget.defaultSupplierCode;
    _supplierName = d?.supplierName ?? widget.defaultSupplierName;
    _noSupplierDiscount = d?.noSupplierDiscount ?? false;
    _conversionUnitCode = d?.conversionUnitCode;
    _conversionUnitName = d?.conversionUnitName;
    _manageDeposit = d?.manageDeposit ?? false;
    _draggedToRegister = d?.draggedToRegister;
    _depositItem = d?.depositItem;
    _misc = d?.misc;
    _delicatessen = d?.delicatessen ?? false;
    _clubCode = d?.clubCode;
    _registerDiscount = d?.registerDiscount;
    _promotion = d?.promotion;

    // מחיר המכירה מתעדכן חי משלושת שדות התמחור.
    for (final c in [_supplierPrice, _discountPct, _profitPct]) {
      c.addListener(_onPricingChanged);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(suppliersProvider.notifier).load();
      ref.read(catalogTaxonomyProvider.notifier).load();
      ref.read(itemFormOptionsProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    for (final c in _allControllers) {
      c.dispose();
    }
    super.dispose();
  }

  List<TextEditingController> get _allControllers => [
        _itemCode,
        _barcode,
        _name,
        _supplierItem,
        _supplierPrice,
        _discountPct,
        _profitPct,
        _conversionQty,
        _packageWeight,
        _calcQty,
      ];

  void _onPricingChanged() => setState(() {});

  // ===========================================================================
  // עזרי מספרים
  // ===========================================================================

  String _fmt(double? v) {
    if (v == null) return '';
    final s = v.toStringAsFixed(2);
    return s.endsWith('.00') ? s.substring(0, s.length - 3) : s;
  }

  double? _parse(TextEditingController c) {
    final t = c.text.trim().replaceAll(',', '.');
    if (t.isEmpty) return null;
    return double.tryParse(t);
  }

  /// שיעור המע"מ להערכה המקומית בלבד (18%).
  ///
  /// ⚠️ נמדד מול 4 מחלקות **חייבות מע"מ**; מחלקה פטורה לא נבדקה. זו עוד סיבה
  /// שהערך המוצג כאן הוא הערכה בלבד וההכרעה היא של השרת.
  static const double _vatRate = 0.18;

  /// **הערכה מקומית** של מחיר המכירה, לתצוגה חיה בזמן הקלדה.
  ///
  /// הנוסחה של Comax היא **מרווח כולל מע"מ, לא תוספת**:
  /// `מחיר ספק × (1 − הנחה%) ÷ (1 − רווח%) × (1 + מע"מ)`.
  /// עלות 100 עם רווח 25% נותנת 157.33, לא 125 — מחלקים, לא מכפילים.
  ///
  /// ⚠️ הערך **המחייב** הוא `resolved.lines[i].newProduct.computedSalePrice`
  /// שחוזר מ-`/documents/validate`. כאן זו רק תצוגה, ולכן היא מסומנת כהערכה.
  double? get _estimatedSalePrice {
    final cost = _parse(_supplierPrice);
    if (cost == null) return null;
    final discount = _parse(_discountPct) ?? 0;
    final profit = _parse(_profitPct) ?? 0;
    // רווח 100% = חלוקה באפס. הוולידציה חוסמת שמירה, אבל התצוגה חייבת לשרוד
    // את מצב הביניים בזמן ההקלדה.
    if (profit >= 100) return null;
    if (discount < 0 || discount > 100) return null;
    final net = cost * (1 - discount / 100);
    final preVat = net / (1 - profit / 100);
    return double.parse((preVat * (1 + _vatRate)).toStringAsFixed(2));
  }

  // ===========================================================================
  // ולידציות מקומיות — חוסכות סבב שרת ומונעות שקטים של Comax
  // ===========================================================================

  static final RegExp _digitsOnly = RegExp(r'^\d+$');

  /// קוד פריט / פריט ספק — ספרות בלבד. טקסט מייצר בקומקס "קוד שגוי !" והשדה נזרק.
  String? _validateItemCode(AppLocalizations l10n) {
    final v = _itemCode.text.trim();
    if (v.isEmpty) return l10n.npRequiredField;
    if (!_digitsOnly.hasMatch(v)) return l10n.npDigitsOnly;
    return null;
  }

  String? _validateSupplierItem(AppLocalizations l10n) {
    final v = _supplierItem.text.trim();
    if (v.isEmpty) return null; // אופציונלי
    if (!_digitsOnly.hasMatch(v)) return l10n.npDigitsOnly;
    return null;
  }

  /// ברקוד תקין: ספרות בלבד, באורך סביר לברקוד קמעונאי.
  String? _validateBarcode(AppLocalizations l10n) {
    final v = _barcode.text.trim();
    if (v.isEmpty) return l10n.npRequiredField;
    if (!_digitsOnly.hasMatch(v) || v.length < 6 || v.length > 14) {
      return l10n.npInvalidBarcode;
    }
    return null;
  }

  String? _validateName(AppLocalizations l10n) =>
      _name.text.trim().isEmpty ? l10n.npRequiredField : null;

  /// % רווח חייב להיות < 100. בדיוק 100 = חלוקה באפס, וקומקס כותב מחיר מכירה 0.
  String? _validateProfit(AppLocalizations l10n) {
    if (_profitPct.text.trim().isEmpty) return null;
    final v = _parse(_profitPct);
    if (v == null || v >= 100 || v < 0) return l10n.npProfitTooHigh;
    return null;
  }

  String? _validateDiscount(AppLocalizations l10n) {
    if (_discountPct.text.trim().isEmpty) return null;
    final v = _parse(_discountPct);
    if (v == null || v < 0 || v > 100) return l10n.npDiscountRange;
    return null;
  }

  /// כפתור השמירה מושבת עד שכל שדות החובה מלאים וכל הוולידציות עוברות.
  bool get _canSave {
    final l10n = AppLocalizations.of(context);
    return _validateItemCode(l10n) == null &&
        _validateBarcode(l10n) == null &&
        _validateName(l10n) == null &&
        _validateSupplierItem(l10n) == null &&
        _validateProfit(l10n) == null &&
        _validateDiscount(l10n) == null &&
        (_departmentCode ?? '').isNotEmpty &&
        (_groupCode ?? '').isNotEmpty &&
        (_supplierCode ?? '').isNotEmpty;
  }

  void _save() {
    if (!_canSave) {
      setState(() => _showErrors = true);
      return;
    }
    final options = ref.read(itemFormOptionsProvider).options;
    String? trimOrNull(TextEditingController c) {
      final v = c.text.trim();
      return v.isEmpty ? null : v;
    }

    /// שדה שאינו קיים אצל הלקוח לא נשלח בשום מקרה — שליחתו מוחזרת כ-
    /// `field_not_available`. זו הגנה שנייה מעבר להסתרת השדה ב-UI, למקרה של
    /// טיוטה ישנה שנשמרה כשהמשתמש היה מחובר ללקוח אחר.
    String? gated(ItemFormOptionList list, String? value) =>
        list.visible ? value : null;

    final draft = NewProductDraft(
      itemCode: _itemCode.text.trim(),
      barcode: _barcode.text.trim(),
      name: _name.text.trim(),
      unitCode: gated(options.units, _unitCode),
      unitName: gated(options.units, _unitName),
      weighable: _weighable,
      departmentCode: _departmentCode,
      departmentName: _departmentName,
      groupCode: _groupCode,
      groupName: _groupName,
      supplierCode: _supplierCode,
      supplierName: _supplierName,
      supplierItem: trimOrNull(_supplierItem),
      supplierPrice: _parse(_supplierPrice),
      discountPct: _parse(_discountPct),
      profitPct: _parse(_profitPct),
      // הערכה בלבד; השרת מחזיר את הערך המחייב באימות.
      salePrice: _estimatedSalePrice,
      noSupplierDiscount: _noSupplierDiscount,
      conversionQty: _parse(_conversionQty),
      conversionUnitCode: gated(options.conversionUnit, _conversionUnitCode),
      conversionUnitName: gated(options.conversionUnit, _conversionUnitName),
      packageWeight: _parse(_packageWeight),
      calcQty: _parse(_calcQty),
      manageDeposit: _manageDeposit,
      draggedToRegister: gated(options.draggedToRegister, _draggedToRegister),
      depositItem: gated(options.depositItem, _depositItem),
      misc: gated(options.misc, _misc),
      delicatessen: _delicatessen,
      clubCode: gated(options.clubCode, _clubCode),
      registerDiscount: gated(options.registerDiscount, _registerDiscount),
      promotion: gated(options.promotion, _promotion),
    );
    Navigator.of(context).pop(draft);
  }

  // ===========================================================================
  // בוררים
  // ===========================================================================

  Future<void> _pickDepartment(AppLocalizations l10n) async {
    final notifier = ref.read(catalogTaxonomyProvider.notifier);
    await notifier.load();
    if (!mounted) return;
    final departments = ref.read(catalogTaxonomyProvider).departments;
    final picked = await showSearchablePicker<CatalogDepartment>(
      context: context,
      title: l10n.npDepartment,
      searchHint: l10n.searchHintGeneric,
      items: departments,
      labelOf: (d) => d.name,
      sublabelOf: (d) => d.code,
    );
    if (picked == null || !mounted) return;
    setState(() {
      _departmentCode = picked.code;
      _departmentName = picked.name;
      // ⚠️ קוד קבוצה אינו ייחודי בין מחלקות — קבוצה שנבחרה תחת מחלקה אחרת אינה
      // בהכרח קיימת כאן, ולכן היא מתאפסת בכל החלפת מחלקה.
      _groupCode = null;
      _groupName = null;
    });
  }

  Future<void> _pickGroup(AppLocalizations l10n) async {
    final dept = _departmentCode;
    if (dept == null || dept.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.npSelectDepartmentFirst)));
      return;
    }
    final notifier = ref.read(catalogTaxonomyProvider.notifier);
    await notifier.load();
    if (!mounted) return;
    final groups = ref.read(catalogTaxonomyProvider).groupsForDepartment(dept);
    final picked = await showSearchablePicker<CatalogGroup>(
      context: context,
      title: l10n.npGroup,
      searchHint: l10n.searchHintGeneric,
      items: groups,
      labelOf: (g) => g.name,
      sublabelOf: (g) => g.code,
    );
    if (picked == null || !mounted) return;
    setState(() {
      _groupCode = picked.code;
      _groupName = picked.name;
    });
  }

  Future<void> _pickSupplier(AppLocalizations l10n) async {
    final notifier = ref.read(suppliersProvider.notifier);
    await notifier.load();
    if (!mounted) return;
    final suppliers = ref.read(suppliersProvider).suppliers;
    final picked = await showSearchablePicker<Supplier>(
      context: context,
      title: l10n.npMainSupplier,
      searchHint: l10n.searchHintGeneric,
      items: suppliers,
      labelOf: (s) => s.name,
      sublabelOf: (s) => s.code,
      searchExtra: (s) => s.taxId,
    );
    if (picked == null || !mounted) return;
    setState(() {
      _supplierCode = picked.code;
      _supplierName = picked.name;
    });
  }

  Future<void> _pickOption(
    AppLocalizations l10n,
    String title,
    ItemFormOptionList list,
    String? current,
    void Function(ItemFormOption?) onPicked,
  ) async {
    // אפשרות "ללא" ראשונה, כדי שאפשר יהיה לנקות בחירה קיימת.
    const clearSentinel = ItemFormOption(code: '\u0000clear', name: '');
    final items = <ItemFormOption>[
      if (current != null && current.isNotEmpty) clearSentinel,
      ...list.options,
    ];
    final picked = await showSearchablePicker<ItemFormOption>(
      context: context,
      title: title,
      searchHint: l10n.searchHintGeneric,
      items: items,
      labelOf: (o) => identical(o, clearSentinel) ? l10n.npNone : o.label,
      sublabelOf: (o) => identical(o, clearSentinel) ? '' : o.code,
    );
    if (picked == null || !mounted) return;
    setState(() => onPicked(identical(picked, clearSentinel) ? null : picked));
  }

  // ===========================================================================
  // בנייה
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final optionsState = ref.watch(itemFormOptionsProvider);
    final options = optionsState.options;
    final isEdit = widget.initialDraft != null;

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: AppBar(
        backgroundColor: AppColors.pageBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          isEdit ? l10n.editProductTitle : l10n.newProductTitle,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              size: 20, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          if (optionsState.loading) const LinearProgressIndicator(minHeight: 2),
          if (optionsState.error != null)
            _optionsBanner(theme, l10n, optionsState.isNoData),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                _section(
                  index: 1,
                  title: l10n.npSectionItem,
                  theme: theme,
                  children: [
                    _text(
                      label: l10n.npBarcode,
                      controller: _barcode,
                      required_: true,
                      keyboardType: TextInputType.number,
                      digitsOnly: true,
                      error: _showErrors ? _validateBarcode(l10n) : null,
                      // סריקת ברקוד ישירות אל השדה — הערך הנסרק נכנס מיד.
                      suffixIcon: IconButton(
                        tooltip: l10n.scanBarcodeTooltip,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 52,
                          minHeight: 52,
                        ),
                        splashRadius: 26,
                        icon: const Icon(
                          CupertinoIcons.barcode_viewfinder,
                          color: AppColors.primary,
                          size: 36,
                        ),
                        onPressed: () async {
                          final code = await scanBarcodeOrQRCode(
                            context: context,
                            cancelText: l10n.cancel,
                            scanMode: ScanMode.BARCODE,
                          );
                          if (!context.mounted) return;
                          if (code.isEmpty || code == '-1') return;
                          _barcode.text = code;
                          _barcode.selection = TextSelection.collapsed(
                              offset: _barcode.text.length);
                          setState(() {}); // מרענן את חישוב _canSave
                        },
                      ),
                    ),
                    _text(
                      label: l10n.npItem,
                      controller: _itemCode,
                      required_: true,
                      keyboardType: TextInputType.number,
                      digitsOnly: true,
                      error: _showErrors ? _validateItemCode(l10n) : null,
                    ),
                    _text(
                      label: l10n.npName,
                      controller: _name,
                      required_: true,
                      error: _showErrors ? _validateName(l10n) : null,
                    ),
                    if (options.units.visible)
                      _picker(
                        label: l10n.npUnit,
                        value: _unitName ?? _unitCode,
                        theme: theme,
                        l10n: l10n,
                        onTap: () => _pickOption(
                          l10n,
                          l10n.npUnit,
                          options.units,
                          _unitCode,
                          (o) {
                            _unitCode = o?.code;
                            _unitName = o?.name;
                          },
                        ),
                      ),
                    _check(
                      label: l10n.npWeighable,
                      value: _weighable,
                      onChanged: (v) => setState(() => _weighable = v),
                    ),
                  ],
                ),
                _section(
                  index: 2,
                  title: l10n.npSectionClassification,
                  theme: theme,
                  children: [
                    _picker(
                      label: l10n.npDepartment,
                      value: _departmentName ?? _departmentCode,
                      required_: true,
                      theme: theme,
                      l10n: l10n,
                      error: _showErrors && (_departmentCode ?? '').isEmpty
                          ? l10n.npRequiredField
                          : null,
                      onTap: () => _pickDepartment(l10n),
                    ),
                    _picker(
                      label: l10n.npGroup,
                      value: _groupName ?? _groupCode,
                      required_: true,
                      theme: theme,
                      l10n: l10n,
                      enabled: (_departmentCode ?? '').isNotEmpty,
                      hint: (_departmentCode ?? '').isEmpty
                          ? l10n.npSelectDepartmentFirst
                          : null,
                      error: _showErrors && (_groupCode ?? '').isEmpty
                          ? l10n.npRequiredField
                          : null,
                      onTap: () => _pickGroup(l10n),
                    ),
                    _picker(
                      label: l10n.npMainSupplier,
                      value: _supplierName ?? _supplierCode,
                      required_: true,
                      theme: theme,
                      l10n: l10n,
                      error: _showErrors && (_supplierCode ?? '').isEmpty
                          ? l10n.npRequiredField
                          : null,
                      onTap: () => _pickSupplier(l10n),
                    ),
                    _text(
                      label: l10n.npSupplierItem,
                      controller: _supplierItem,
                      keyboardType: TextInputType.number,
                      digitsOnly: true,
                      error: _showErrors ? _validateSupplierItem(l10n) : null,
                    ),
                  ],
                ),
                _section(
                  index: 3,
                  title: l10n.npSectionPricing,
                  theme: theme,
                  children: [
                    _text(
                      label: l10n.npSupplierPrice,
                      controller: _supplierPrice,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                    ),
                    _text(
                      label: l10n.npDiscountPct,
                      controller: _discountPct,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      error: _showErrors ? _validateDiscount(l10n) : null,
                    ),
                    _check(
                      label: l10n.npNoSupplierDiscount,
                      value: _noSupplierDiscount,
                      onChanged: (v) => setState(() => _noSupplierDiscount = v),
                    ),
                    _text(
                      label: l10n.npProfitPct,
                      controller: _profitPct,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      error: _showErrors ? _validateProfit(l10n) : null,
                    ),
                    _salePriceRow(theme, l10n),
                  ],
                ),
                _section(
                  index: 4,
                  title: l10n.npSectionPackaging,
                  theme: theme,
                  children: [
                    _text(
                      label: l10n.npConversionQty,
                      controller: _conversionQty,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                    ),
                    if (options.conversionUnit.visible)
                      _picker(
                        label: l10n.npConversionUnit,
                        value: _conversionUnitName ?? _conversionUnitCode,
                        theme: theme,
                        l10n: l10n,
                        onTap: () => _pickOption(
                          l10n,
                          l10n.npConversionUnit,
                          options.conversionUnit,
                          _conversionUnitCode,
                          (o) {
                            _conversionUnitCode = o?.code;
                            _conversionUnitName = o?.name;
                          },
                        ),
                      ),
                    _text(
                      label: l10n.npPackageWeight,
                      controller: _packageWeight,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                    ),
                    _text(
                      label: l10n.npCalcQty,
                      controller: _calcQty,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ],
                ),
                _section(
                  index: 5,
                  title: l10n.npSectionDeposit,
                  theme: theme,
                  children: [
                    _check(
                      label: l10n.npManageDeposit,
                      value: _manageDeposit,
                      onChanged: (v) => setState(() => _manageDeposit = v),
                    ),
                    if (options.draggedToRegister.visible)
                      _picker(
                        label: l10n.npDraggedToRegister,
                        value: options.draggedToRegister
                            .byCode(_draggedToRegister)
                            ?.label,
                        theme: theme,
                        l10n: l10n,
                        onTap: () => _pickOption(
                          l10n,
                          l10n.npDraggedToRegister,
                          options.draggedToRegister,
                          _draggedToRegister,
                          (o) => _draggedToRegister = o?.code,
                        ),
                      ),
                    if (options.depositItem.visible)
                      _picker(
                        label: l10n.npDepositItem,
                        value: options.depositItem.byCode(_depositItem)?.label,
                        theme: theme,
                        l10n: l10n,
                        onTap: () => _pickOption(
                          l10n,
                          l10n.npDepositItem,
                          options.depositItem,
                          _depositItem,
                          (o) => _depositItem = o?.code,
                        ),
                      ),
                    _check(
                      label: l10n.npDelicatessen,
                      value: _delicatessen,
                      onChanged: (v) => setState(() => _delicatessen = v),
                    ),
                    if (options.misc.visible)
                      _picker(
                        label: l10n.npMisc,
                        value: options.misc.byCode(_misc)?.label,
                        theme: theme,
                        l10n: l10n,
                        onTap: () => _pickOption(
                          l10n,
                          l10n.npMisc,
                          options.misc,
                          _misc,
                          (o) => _misc = o?.code,
                        ),
                      ),
                  ],
                ),
                // אזור 6 קיים רק אם לפחות אחד משלושת השדות קיים אצל הלקוח.
                if (options.hasRegisterAndClubSection)
                  _section(
                    index: 6,
                    title: l10n.npSectionRegisterClub,
                    theme: theme,
                    children: [
                      if (options.clubCode.visible)
                        _picker(
                          label: l10n.npClubCode,
                          value: options.clubCode.byCode(_clubCode)?.label,
                          theme: theme,
                          l10n: l10n,
                          onTap: () => _pickOption(
                            l10n,
                            l10n.npClubCode,
                            options.clubCode,
                            _clubCode,
                            (o) => _clubCode = o?.code,
                          ),
                        ),
                      if (options.registerDiscount.visible)
                        _picker(
                          label: l10n.npRegisterDiscount,
                          value: options.registerDiscount
                              .byCode(_registerDiscount)
                              ?.label,
                          theme: theme,
                          l10n: l10n,
                          onTap: () => _pickOption(
                            l10n,
                            l10n.npRegisterDiscount,
                            options.registerDiscount,
                            _registerDiscount,
                            (o) => _registerDiscount = o?.code,
                          ),
                        ),
                      if (options.promotion.visible)
                        _picker(
                          label: l10n.npPromotion,
                          value: options.promotion.byCode(_promotion)?.label,
                          theme: theme,
                          l10n: l10n,
                          onTap: () => _pickOption(
                            l10n,
                            l10n.npPromotion,
                            options.promotion,
                            _promotion,
                            (o) => _promotion = o?.code,
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
          // סרגל שמירה צף מעל התוכן — כרטיס לבן עם צל הפוך, כדי שהרשימה
          // הארוכה תיראה נגללת "מתחתיו" ולא נחתכת.
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow.withOpacity(0.06),
                  blurRadius: 16,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_showErrors && !_canSave)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          l10n.npRequiredMissing,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: AppColors.error),
                        ),
                      ),
                    // ⚠️ GradientButton לא מדהה את עצמו כש-onPressed הוא null —
                    // הגרדיאנט נשאר מלא וההשבתה נראית זהה למצב פעיל. העטיפה
                    // ב-Opacity היא מה שהופך את ההשבתה לנראית.
                    Opacity(
                      opacity: _canSave ? 1 : 0.45,
                      child: SizedBox(
                        width: double.infinity,
                        child: GradientButton(
                          label: l10n.npSave,
                          // גרדיאנט המותג (כחול→ירוק), כמו "שמור" בפרופיל.
                          colors: const [
                            AppColors.headerGradientStart,
                            AppColors.headerGradientEnd,
                          ],
                          // מושבת עד שכל שדות החובה מלאים.
                          onPressed: _canSave ? _save : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _optionsBanner(ThemeData theme, AppLocalizations l10n, bool isNoData) {
    return Container(
      width: double.infinity,
      color: AppColors.warning.withOpacity(0.15),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          const Icon(CupertinoIcons.exclamationmark_triangle,
              size: 18, color: AppColors.warning),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              isNoData ? l10n.npOptionsNoData : l10n.npOptionsError,
              style: theme.textTheme.bodySmall,
            ),
          ),
          TextButton(
            onPressed: () =>
                ref.read(itemFormOptionsProvider.notifier).load(force: true),
            child: Text(l10n.retry),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // שפת העיצוב — זהה לטפסים של האפליקציה הראשית (`ui/screens/profile_screen.dart`):
  // כרטיס לבן radius 16 עם צל רך על רקע אפור, תווית 13px עם כוכבית אדומה,
  // ושדה **ממולא באפור בלי מסגרת** (השדה "נחתך" מהכרטיס במקום להיות ממוסגר).
  // ---------------------------------------------------------------------------

  static const double _fieldRadius = 12;
  static const double _fieldGap = 14;

  /// גבול השדה. אותה צורה בכל המצבים — רק צבע הקו משתנה, כדי שהשדה לא "יקפוץ".
  OutlineInputBorder _fieldBorder([Color? color]) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(_fieldRadius),
        borderSide: color == null
            ? BorderSide.none
            : BorderSide(color: color, width: 1.2),
      );

  InputDecoration _fieldDecoration({
    String? error,
    String? hint,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      isDense: true,
      filled: true,
      fillColor: AppColors.fieldFill,
      errorText: error,
      hintText: hint,
      suffixIcon: suffixIcon,
      suffixIconConstraints: suffixIcon == null
          ? null
          : const BoxConstraints(minWidth: 56, minHeight: 56),
      hintStyle: const TextStyle(
          fontSize: 14, color: AppColors.textSecondary, fontWeight: FontWeight.w400),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: _fieldBorder(),
      enabledBorder: _fieldBorder(),
      disabledBorder: _fieldBorder(),
      focusedBorder: _fieldBorder(AppColors.primary),
      errorBorder: _fieldBorder(AppColors.error),
      focusedErrorBorder: _fieldBorder(AppColors.error),
    );
  }

  /// אזור מתקפל, ככרטיס טופס. אזורים 1–3 פתוחים כברירת מחדל, 4–6 סגורים.
  Widget _section({
    required int index,
    required String title,
    required ThemeData theme,
    required List<Widget> children,
  }) {
    final open = _expanded.contains(index);
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () => setState(() {
              if (open) {
                _expanded.remove(index);
              } else {
                _expanded.add(index);
              }
            }),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, open ? 4 : 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Icon(
                    open
                        ? CupertinoIcons.chevron_up
                        : CupertinoIcons.chevron_down,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
          if (open)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children,
              ),
            ),
        ],
      ),
    );
  }

  /// תווית שדה. בעברית (RTL) הילד הראשון ב-Row הוא הימני, ולכן הכוכבית האדומה
  /// מופיעה **לפני** הטקסט — בדיוק כמו ב-`profile_screen`.
  Widget _label(String text, {bool required_ = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (required_)
            const Text('* ',
                style: TextStyle(fontSize: 13, color: AppColors.error)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary.withOpacity(0.55),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _text({
    required String label,
    required TextEditingController controller,
    bool required_ = false,
    TextInputType? keyboardType,
    bool digitsOnly = false,
    String? error,
    Widget? suffixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: _fieldGap),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label(label, required_: required_),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            cursorColor: AppColors.primary,
            style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
            inputFormatters:
                digitsOnly ? [FilteringTextInputFormatter.digitsOnly] : null,
            onChanged: (_) {
              // מפעיל מחדש את חישוב _canSave (הכפתור נעול עד שהחובה מלאים).
              setState(() {});
            },
            decoration: _fieldDecoration(error: error, suffixIcon: suffixIcon),
          ),
        ],
      ),
    );
  }

  Widget _picker({
    required String label,
    required String? value,
    required ThemeData theme,
    required AppLocalizations l10n,
    required VoidCallback onTap,
    bool required_ = false,
    bool enabled = true,
    String? hint,
    String? error,
  }) {
    final shown = (value ?? '').trim();
    return Padding(
      padding: const EdgeInsets.only(bottom: _fieldGap),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label(label, required_: required_),
          InkWell(
            onTap: enabled ? onTap : null,
            borderRadius: BorderRadius.circular(_fieldRadius),
            child: InputDecorator(
              decoration: _fieldDecoration(error: error).copyWith(
                enabled: enabled,
                // מרווח אנכי מעט קטן יותר: ה-Row הפנימי כבר גבוה מטקסט רגיל,
                // בלי זה השדה הנבחר גבוה מהשדות שלידו.
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      shown.isEmpty ? (hint ?? l10n.selectHint) : shown,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            shown.isEmpty ? FontWeight.w400 : FontWeight.w500,
                        color: shown.isEmpty
                            ? AppColors.textSecondary
                            : AppColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(CupertinoIcons.chevron_down,
                      size: 15, color: AppColors.textSecondary),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// צ'קבוקס כשורה ממולאת — נקרא כשדה, לא כפריט רשימה חופשי.
  Widget _check({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: _fieldGap),
      child: Material(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(_fieldRadius),
        child: InkWell(
          onTap: () => onChanged(!value),
          borderRadius: BorderRadius.circular(_fieldRadius),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Row(
              children: [
                Checkbox(
                  value: value,
                  onChanged: (v) => onChanged(v ?? false),
                  activeColor: AppColors.primary,
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(label,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// מחיר מכירה — מוצג בלבד, מתעדכן חי, ומסומן במפורש כהערכה.
  Widget _salePriceRow(ThemeData theme, AppLocalizations l10n) {
    final estimate = _estimatedSalePrice;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(_fieldRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(l10n.npSalePrice,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary)),
              ),
              Text(
                estimate == null
                    ? AppConstants.emptyFieldPlaceholder
                    : '₪${estimate.toStringAsFixed(2)}',
                style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700, color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(l10n.npSalePriceEstimate,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: AppColors.textSecondary, fontSize: 11)),
        ],
      ),
    );
  }
}
