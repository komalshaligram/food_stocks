import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/model/req_model/insert_cart_req_model/insert_cart_req_model.dart' as insert;
import '../../data/model/req_model/update_cart/update_cart_req_model.dart';
import '../../data/model/res_model/sale_participating_products_res_model/sale_participating_products_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../utils/app_utils.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_img_path.dart';
import '../utils/constants/app_styles.dart';
import '../utils/constants/app_urls.dart';
import 'sized_box_widget.dart';

Future<bool> showSalePromotionSheet(
    {required BuildContext context, required String productId, required AppLocalizations l10n, int? initialQuantity}) async {
  final bool? changed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.blackColor.withValues(alpha: 0.45),
      builder: (sheetContext) => SalePromotionSheet(productId: productId, l10n: l10n, initialQuantity: initialQuantity));
  return changed ?? false;
}

class _PromoItem {
  _PromoItem(
      {required this.id,
      required this.name,
      required this.image,
      required this.salePrice,
      required this.originalPrice,
      required this.numberOfUnit,
      required this.supplierId,
      required this.cartProductId,
      required this.originalQty,
      required this.desiredQty,
      required this.isCurrent});

  final String id;
  final String name;
  final String image;
  final double salePrice;
  final double originalPrice;
  final String numberOfUnit;
  final String supplierId;
  String cartProductId;
  final int originalQty;
  int desiredQty;
  final bool isCurrent;
}

class SalePromotionSheet extends StatefulWidget {
  const SalePromotionSheet({super.key, required this.productId, required this.l10n, this.initialQuantity});

  final String productId;
  final AppLocalizations l10n;
  final int? initialQuantity;

  @override
  State<SalePromotionSheet> createState() => _SalePromotionSheetState();
}

class _SalePromotionSheetState extends State<SalePromotionSheet> {
  bool _loading = true;
  bool _committing = false;
  bool _isMixed = false;
  int _min = 0;
  String _cartId = '';
  final List<_PromoItem> _items = [];

  AppLocalizations get l10n => widget.l10n;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final dio = DioClient(context);
    try {
      final preferences = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
      _cartId = preferences.getCartId();
      final res = await dio.post(AppUrlEndPoints.getSaleParticipatingProductsUrl, data: {'productId': widget.productId});
      final model = SaleParticipatingProductsResModel.fromJson(res);
      final products = model.products ?? [];
      _min = (model.saleMinQuantity ?? 0).round();
      _isMixed = model.isMixedSale ?? (products.length > 1);
      if ((model.cartId ?? '').isNotEmpty) _cartId = model.cartId!;
      _items
        ..clear()
        ..addAll(products.map(_toItem));
    } catch (_) {
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  _PromoItem _toItem(SaleParticipatingProduct p) {
    final int cartQty = (p.cartQuantity ?? 0).round();
    final bool isCurrent = p.isCurrent ?? (p.id == widget.productId);
    final int desiredQty = (isCurrent && widget.initialQuantity != null) ? widget.initialQuantity! : cartQty;
    return _PromoItem(
        id: p.id ?? '',
        name: p.name ?? '',
        image: p.image ?? '',
        salePrice: double.tryParse(p.salePrice ?? '') ?? 0,
        originalPrice: double.tryParse(p.originalPrice ?? '') ?? 0,
        numberOfUnit: p.numberOfUnit ?? '',
        supplierId: p.supplierId ?? '',
        cartProductId: p.cartProductId ?? '',
        originalQty: cartQty,
        desiredQty: desiredQty,
        isCurrent: isCurrent);
  }

  int get _selectedTotal => _items.fold(0, (sum, item) => sum + item.desiredQty);
  double get _totalPrice => _items.fold(0.0, (sum, item) => sum + item.desiredQty * item.salePrice * int.parse(item.numberOfUnit));
  bool get _minReached => _selectedTotal >= _min;
  bool get _hasChanges => _items.any((item) => item.desiredQty != item.originalQty);

  void _increment(_PromoItem item) {
    setState(() => item.desiredQty += 1);
  }

  void _decrement(_PromoItem item) {
    if (item.desiredQty <= 0) return;
    setState(() => item.desiredQty -= 1);
  }

  Future<void> _commit() async {
    if (_committing) return;
    if (!_hasChanges) {
      Navigator.pop(context, true);
      return;
    }
    setState(() => _committing = true);
    final dio = DioClient(context);
    bool anyFailure = false;
    try {
      final List<insert.Product> toInsert = [];
      for (final item in _items) {
        if (item.desiredQty == item.originalQty) continue;
        if (item.cartProductId.isEmpty) {
          if (item.desiredQty > 0) {
            toInsert.add(insert.Product(productId: item.id, quantity: item.desiredQty, supplierId: item.supplierId, note: '', saleId: null));
          }
        } else if (item.desiredQty > 0) {
          anyFailure |= !await _updateLine(dio, item);
        } else {
          anyFailure |= !await _removeLine(dio, item);
        }
      }
      if (toInsert.isNotEmpty) {
        anyFailure |= !await _insertLines(dio, toInsert);
      }
    } catch (_) {
      anyFailure = true;
    }

    if (!mounted) return;
    if (anyFailure) {
      setState(() => _committing = false);
      CustomSnackBar.showSnackBar(context: context, title: l10n.connection_error, type: SnackBarType.failure);
      return;
    }
    Navigator.pop(context, true);
  }

  Future<bool> _insertLines(DioClient dio, List<insert.Product> products) async {
    final Map<String, dynamic> req = insert.InsertCartReqModel(products: products).toJson();
    req.removeWhere((key, value) => value == null);
    final res = await dio.post('${AppUrlEndPoints.insertProductInCartUrl}$_cartId', data: req);
    return res is Map && res['status'] == AppConstants.code_201;
  }

  Future<bool> _updateLine(DioClient dio, _PromoItem item) async {
    final request = UpdateCartReqModel(
        productId: item.id, supplierId: item.supplierId, quantity: item.desiredQty, saleId: null, cartProductId: item.cartProductId);
    final res = await dio.post('${AppUrlEndPoints.updateCartProductUrl}$_cartId', data: request);
    return res is Map && res['status'] == AppConstants.code_201;
  }

  Future<bool> _removeLine(DioClient dio, _PromoItem item) async {
    final res = await dio.post(AppUrlEndPoints.removeCartProductUrl, data: {'cartProductId': item.cartProductId});
    return res is Map && res['status'] == AppConstants.code_200;
  }

  @override
  Widget build(BuildContext context) {
    final double maxHeight = getScreenHeight(context) * 0.85;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        constraints: BoxConstraints(maxHeight: maxHeight),
        decoration:
            BoxDecoration(color: AppColors.whiteColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(AppConstants.radius_25))),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          _buildHandle(),
          _buildHeader(),
          if (_loading)
            _buildLoading()
          else if (_items.isEmpty)
            _buildEmpty()
          else ...[
            _buildProgress(),
            Flexible(child: _buildList()),
            _buildFooter(),
          ]
        ]),
      ),
    );
  }

  Widget _buildHandle() => Container(
        margin: const EdgeInsets.only(top: 12, bottom: 4),
        width: 44,
        height: 5,
        decoration: BoxDecoration(color: AppColors.borderColor, borderRadius: BorderRadius.circular(AppConstants.radius_10)),
      );

  Widget _buildHeader() => Padding(
        padding: const EdgeInsets.fromLTRB(AppConstants.padding_20, AppConstants.padding_10, AppConstants.padding_15, 0),
        child: Row(children: [
          Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(gradient: AppColors.appMainGradientColor, borderRadius: BorderRadius.circular(AppConstants.radius_10)),
              child: const Icon(Icons.local_offer_outlined, color: Colors.white, size: 19)),
          8.width,
          Expanded(
            child: Text(_isMixed ? l10n.mixedSale : l10n.promo_sheet_reach_min_title,
                style: AppStyles.rkBoldTextStyle(size: AppConstants.font_17, color: AppColors.blackColor)),
          ),
          InkWell(
            onTap: _committing ? null : () => Navigator.pop(context, false),
            borderRadius: BorderRadius.circular(AppConstants.radius_100),
            child: Padding(padding: const EdgeInsets.all(6), child: Icon(Icons.close, color: AppColors.greyColor, size: 22)),
          ),
        ]),
      );

  Widget _buildProgress() {
    final int remaining = (_min - _selectedTotal).clamp(0, _min);
    final double ratio = _min <= 0 ? 1 : (_selectedTotal / _min).clamp(0.0, 1.0);
    return Container(
      margin: const EdgeInsets.fromLTRB(AppConstants.padding_15, AppConstants.padding_15, AppConstants.padding_15, AppConstants.padding_5),
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_15, vertical: AppConstants.padding_11),
      decoration: BoxDecoration(
          color: (_minReached ? AppColors.mainColor : AppColors.blueColor).withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(AppConstants.radius_15)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            Text(l10n.promo_sheet_of_packages(_selectedTotal, _min),
                style: AppStyles.rkBoldTextStyle(size: AppConstants.font_15, color: AppColors.blackColor)),
            const Spacer(),
            if (_minReached) Icon(Icons.check_circle, color: AppColors.mainColor, size: 20)
          ],
        ),
        8.height,
        ClipRRect(
          borderRadius: BorderRadius.circular(AppConstants.radius_10),
          child: LinearProgressIndicator(
              value: ratio,
              minHeight: 8,
              backgroundColor: AppColors.borderColor.withValues(alpha: 0.6),
              valueColor: AlwaysStoppedAnimation(_minReached ? AppColors.mainColor : AppColors.blueColor)),
        ),
        6.height,
        Text(_minReached ? l10n.promo_sheet_min_reached : l10n.promo_sheet_remaining(remaining),
            style: AppStyles.rkRegularTextStyle(size: AppConstants.font_12, color: _minReached ? AppColors.mainColor : AppColors.greyColor)),
      ]),
    );
  }

  Widget _buildList() => ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_15, vertical: AppConstants.padding_5),
      itemCount: _items.length,
      separatorBuilder: (_, __) => Divider(height: 1, color: AppColors.borderColor.withValues(alpha: 0.5)),
      itemBuilder: (context, index) => _buildRow(_items[index]));

  Widget _buildRow(_PromoItem item) {
    final bool hasDiscount = item.originalPrice > item.salePrice;
    final double boxPrice = item.salePrice * int.parse(item.numberOfUnit);
    final String boxPriceTotal = '₪${boxPrice.toStringAsFixed(2)}';
    final double originalPrice = item.originalPrice * int.parse(item.numberOfUnit);
    final String originalPriceTotal = '₪${originalPrice.toStringAsFixed(2)}';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_10),
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppConstants.radius_10),
          child: SizedBox(
              width: 54,
              height: 54,
              child: item.image.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: '${AppUrlEndPoints.baseFileUrl}${item.image}',
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(color: AppColors.pageColor),
                      errorWidget: (context, error, stackTrace) => Image.asset(AppImagePath.imageNotAvailable5, fit: BoxFit.cover))
                  : Image.asset(AppImagePath.imageNotAvailable5, fit: BoxFit.cover)),
        ),
        10.width,
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(item.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14, color: AppColors.blackColor, fontWeight: FontWeight.w600)),
            if (item.numberOfUnit.isNotEmpty && item.numberOfUnit != '0') ...[
              2.height,
              Text('${item.numberOfUnit} ${l10n.unit_in_box}',
                  style: AppStyles.rkRegularTextStyle(size: AppConstants.font_12, color: AppColors.greyColor))
            ],
            4.height,
            Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(boxPriceTotal, style: AppStyles.rkBoldTextStyle(size: AppConstants.font_15, color: AppColors.saleRedColor)),
              if (hasDiscount) ...[
                6.width,
                Text(originalPriceTotal,
                    style: AppStyles.rkRegularTextStyle(
                      size: AppConstants.font_12,
                      color: AppColors.greyColor,
                    ).copyWith(decoration: TextDecoration.lineThrough)),
              ]
            ]),
          ]),
        ),
        8.width,
        _buildStepper(item)
      ]),
    );
  }

  Widget _buildStepper(_PromoItem item) {
    final bool canDecrease = item.desiredQty > 0;
    return Container(
      decoration: BoxDecoration(
          color: AppColors.pageColor, borderRadius: BorderRadius.circular(AppConstants.radius_25), border: Border.all(color: AppColors.borderColor)),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        _stepperButton(icon: Icons.remove, enabled: canDecrease && !_committing, onTap: () => _decrement(item)),
        Container(
            constraints: const BoxConstraints(minWidth: 30),
            alignment: Alignment.center,
            child: Text(item.desiredQty.toString(), style: AppStyles.rkBoldTextStyle(size: AppConstants.font_15, color: AppColors.blackColor))),
        _stepperButton(icon: Icons.add, enabled: !_committing, filled: true, onTap: () => _increment(item))
      ]),
    );
  }

  Widget _stepperButton({required IconData icon, required bool enabled, required VoidCallback onTap, bool filled = false}) => GestureDetector(
        onTap: enabled ? onTap : null,
        child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
                gradient: filled && enabled ? AppColors.appMainGradientColor : null,
                color: filled ? (enabled ? null : AppColors.greyColor) : Colors.transparent,
                borderRadius: BorderRadius.circular(AppConstants.radius_25)),
            child: Icon(icon, size: 18, color: filled ? AppColors.whiteColor : (enabled ? AppColors.blackColor : AppColors.borderColor))),
      );

  Widget _buildFooter() => Container(
        padding: EdgeInsets.fromLTRB(AppConstants.padding_20, AppConstants.padding_10, AppConstants.padding_20,
            AppConstants.padding_10 + MediaQuery.of(context).padding.bottom),
        decoration: BoxDecoration(color: AppColors.whiteColor, border: Border(top: BorderSide(color: AppColors.borderColor.withValues(alpha: 0.6)))),
        child: Row(children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Text(l10n.total, style: AppStyles.rkRegularTextStyle(size: AppConstants.font_12, color: AppColors.greyColor)),
            Text('₪${_totalPrice.toStringAsFixed(2)}', style: AppStyles.rkBoldTextStyle(size: AppConstants.font_20, color: AppColors.blackColor))
          ]),
          const Spacer(),
          _buildCta()
        ]),
      );

  Widget _buildCta() {
    final bool enabled = _hasChanges && !_committing;
    return GestureDetector(
      onTap: enabled ? _commit : null,
      child: Container(
          constraints: const BoxConstraints(minWidth: 150),
          height: 48,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_20),
          decoration: BoxDecoration(
              gradient: enabled ? AppColors.appMainGradientColor : AppColors.disableGradientColor,
              borderRadius: BorderRadius.circular(AppConstants.radius_15)),
          child: _committing
              ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.4))
              : Text(l10n.promo_sheet_add_to_cart, style: AppStyles.rkBoldTextStyle(size: AppConstants.font_15, color: AppColors.whiteColor))),
    );
  }

  Widget _buildLoading() =>
      Padding(padding: const EdgeInsets.symmetric(vertical: 60), child: Center(child: CircularProgressIndicator(color: AppColors.mainColor)));

  Widget _buildEmpty() => Padding(
        padding: const EdgeInsets.fromLTRB(AppConstants.padding_20, 40, AppConstants.padding_20, 40),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.info_outline, color: AppColors.greyColor, size: 40),
          12.height,
          Text(l10n.promo_sheet_empty,
              textAlign: TextAlign.center, style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14, color: AppColors.greyColor)),
          20.height,
          GestureDetector(
              onTap: () => Navigator.pop(context, false),
              child: Text(l10n.closeText, style: AppStyles.rkBoldTextStyle(size: AppConstants.font_15, color: AppColors.mainColor))),
        ]),
      );
}
