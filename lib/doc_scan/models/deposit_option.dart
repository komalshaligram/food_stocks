/// אפשרות בדרופדאון פיקדון (שונות / נגרר לקופה / פריט פקדון).
class DepositOption {
  const DepositOption({required this.code, required this.name, this.barcode});

  final String code;
  final String name;
  final String? barcode;

  factory DepositOption.fromJson(Map<String, dynamic> json) => DepositOption(
        code: (json['code'] ?? '').toString(),
        name: (json['name'] ?? '').toString(),
        barcode: json['barcode']?.toString(),
      );
}
