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
    required this.totalPrice,
  });

  final int lineNumber;
  final String? itemNumber;
  final String description;
  final double quantity;
  final int? packages;
  final int? units;
  final double pricePerUnit;
  final double totalPrice;

  Map<String, dynamic> toJson() => {
        'lineNumber': lineNumber,
        'itemNumber': itemNumber,
        'description': description,
        'quantity': quantity,
        'packages': packages,
        'units': units,
        'pricePerUnit': pricePerUnit,
        'totalPrice': totalPrice,
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
      totalPrice: (json['totalPrice'] as num).toDouble(),
    );
  }

  InvoiceItem copyWith({
    int? lineNumber,
    String? itemNumber,
    String? description,
    double? quantity,
    int? packages,
    int? units,
    double? pricePerUnit,
    double? totalPrice,
  }) {
    return InvoiceItem(
      lineNumber: lineNumber ?? this.lineNumber,
      itemNumber: itemNumber ?? this.itemNumber,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      packages: packages ?? this.packages,
      units: units ?? this.units,
      pricePerUnit: pricePerUnit ?? this.pricePerUnit,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}
