import 'new_product_draft.dart';

/// סמן פנימי שמבדיל בין "לא הועבר ארגומנט" (השאר כפי שהוא) לבין העברת null (אפס/נקה).
const Object _undefined = Object();

/// פריט שורה בחשבונית.
class InvoiceItem {
  const InvoiceItem({
    required this.lineNumber,
    this.itemNumber,
    required this.description,
    required this.quantity,
    this.packages,
    this.units,
    required this.pricePerUnit,
    this.discountPercent,
    this.packagingDepositTax,
    required this.totalPrice,
    this.newProduct,
  });

  final int lineNumber;
  final String? itemNumber;
  final String description;
  final double quantity;
  final int? packages;
  final int? units;
  final double pricePerUnit;
  /// אחוז הנחה לשורה אם מופיע במסמך (למשל 99.99 = 99.99%), אחרת null.
  final double? discountPercent;
  /// תוספות לשורה: ערך אריזה + מס קנייה + פיקדון (סכום), אחרת null.
  final double? packagingDepositTax;
  final double totalPrice;

  /// טיוטת "פריט חדש" שנוצרה לשורה (כשהברקוד אינו בקטלוג). null אם לא נוצר.
  final NewProductDraft? newProduct;

  /// מחיר ליחידה סופי (אחרי הנחה ותוספות) = סה"כ ÷ כמות. מחושב, לא נשמר.
  double? get finalUnitPrice {
    if (quantity == 0) return null;
    return totalPrice / quantity;
  }

  Map<String, dynamic> toJson() => {
        'lineNumber': lineNumber,
        'itemNumber': itemNumber,
        'description': description,
        'quantity': quantity,
        'packages': packages,
        'units': units,
        'pricePerUnit': pricePerUnit,
        'discountPercent': discountPercent,
        'packagingDepositTax': packagingDepositTax,
        'totalPrice': totalPrice,
        'newProduct': newProduct?.toJson(),
      };

  factory InvoiceItem.fromJson(Map<String, dynamic> json) {
    return InvoiceItem(
      lineNumber: (json['lineNumber'] as num).toInt(),
      itemNumber: json['itemNumber'] as String?,
      description: json['description'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      packages: json['packages'] != null ? (json['packages'] as num).toInt() : null,
      units: json['units'] != null ? (json['units'] as num).toInt() : null,
      pricePerUnit: (json['pricePerUnit'] as num).toDouble(),
      discountPercent: (json['discountPercent'] as num?)?.toDouble(),
      packagingDepositTax: (json['packagingDepositTax'] as num?)?.toDouble(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      newProduct: json['newProduct'] is Map
          ? NewProductDraft.fromJson(
              Map<String, dynamic>.from(json['newProduct'] as Map))
          : null,
    );
  }

  /// השדות ה-nullable (itemNumber/packages/units/discountPercent) משתמשים ב-[_undefined]:
  /// אם לא הועבר ארגומנט — הערך נשמר; אם הועבר null מפורש — השדה מתאפס.
  InvoiceItem copyWith({
    int? lineNumber,
    Object? itemNumber = _undefined,
    String? description,
    double? quantity,
    Object? packages = _undefined,
    Object? units = _undefined,
    double? pricePerUnit,
    Object? discountPercent = _undefined,
    Object? packagingDepositTax = _undefined,
    double? totalPrice,
    Object? newProduct = _undefined,
  }) {
    return InvoiceItem(
      lineNumber: lineNumber ?? this.lineNumber,
      itemNumber:
          identical(itemNumber, _undefined) ? this.itemNumber : itemNumber as String?,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      packages: identical(packages, _undefined) ? this.packages : packages as int?,
      units: identical(units, _undefined) ? this.units : units as int?,
      pricePerUnit: pricePerUnit ?? this.pricePerUnit,
      discountPercent: identical(discountPercent, _undefined)
          ? this.discountPercent
          : discountPercent as double?,
      packagingDepositTax: identical(packagingDepositTax, _undefined)
          ? this.packagingDepositTax
          : packagingDepositTax as double?,
      totalPrice: totalPrice ?? this.totalPrice,
      newProduct: identical(newProduct, _undefined)
          ? this.newProduct
          : newProduct as NewProductDraft?,
    );
  }
}
