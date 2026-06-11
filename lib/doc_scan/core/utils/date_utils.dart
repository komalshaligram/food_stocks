import 'package:intl/intl.dart';

/// פורמט תאריך לתצוגה (מקומי עברי).
String formatDisplayDate(DateTime date) {
  return DateFormat.yMd('he').format(date);
}

/// פורמט תאריך ושעה לתצוגה (מקומי עברי).
String formatDisplayDateTime(DateTime date) {
  return DateFormat.yMd('he').add_Hm().format(date);
}
