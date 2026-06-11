import 'package:intl/intl.dart';

import '../constants/app_constants.dart';

/// Optional integer column (packs, units per pack) — null and zero show as empty.
String displayOptionalInt(int? value) {
  if (value == null || value == 0) return AppConstants.emptyFieldPlaceholder;
  return value.toString();
}

/// פורמט מטבע ישראלי (1,234.56 ₪).
String formatCurrency(double value) {
  return NumberFormat.currency(
    locale: 'he_IL',
    symbol: '₪',
    decimalDigits: 2,
  ).format(value);
}
