import 'package:intl/intl.dart';

class DateFormatter {
  static String getGroupTitle(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final checkDate = DateTime(date.year, date.month, date.day);

    if (checkDate == today) return 'Сьогодні';
    if (checkDate == yesterday) return 'Вчора';
    return DateFormat('d MMMM yyyy', 'uk_UA').format(date);
  }
}