import '../../models/comax_document_status.dart';

/// מנסח את [InvoiceDiagnosis] כמשפט אחד קריא בעברית.
///
/// "Comax ייבא 21 מתוך 22 שורות. הפריט 'טבק נקסט פיין' לא קיים ב-Comax. הפרש: 369.45 ₪."
///
/// מוחזר null כשאין מה לומר — אז המסך נופל להודעה הגנרית.
String? describeDiagnosis(InvoiceDiagnosis? d) {
  if (d == null || d.isEmpty) return null;
  final parts = <String>[];

  if (d.importedCount != null && d.expectedCount != null) {
    parts.add('Comax ייבא ${d.importedCount} מתוך ${d.expectedCount} שורות.');
  }

  if (d.missingItems.isNotEmpty) {
    final names = d.missingItems.take(3).map((m) => "'${m.name}'").join(', ');
    final more = d.missingItems.length > 3
        ? ' ועוד ${d.missingItems.length - 3}'
        : '';
    final single = d.missingItems.length == 1;
    final allNotInComax =
        d.missingItems.every((m) => m.reason == 'not_in_comax');
    final subject = single ? 'הפריט' : 'הפריטים';
    parts.add(allNotInComax
        ? '$subject $names$more ${single ? 'אינו קיים' : 'אינם קיימים'} ב-Comax.'
        : '$subject $names$more לא ${single ? 'יובא' : 'יובאו'}.');
  }

  if (d.lineDiffs.isNotEmpty) {
    parts.add(d.lineDiffs.length == 1
        ? 'שורה אחת יובאה בערכים שונים.'
        : '${d.lineDiffs.length} שורות יובאו בערכים שונים.');
  }

  final delta = d.totalDelta;
  if (delta != null && delta.abs() >= 0.01) {
    parts.add('הפרש: ${delta.abs().toStringAsFixed(2)} ₪.');
  }

  return parts.isEmpty ? null : parts.join(' ');
}
