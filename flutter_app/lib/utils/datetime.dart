import 'package:intl/intl.dart';

String formatDate(int timestamp) {
  DateTime dt = DateTime.fromMillisecondsSinceEpoch(timestamp);

  return DateFormat('dd MMM yyyy').format(dt);
}

String formatDateMonth(int timestamp) {
  DateTime dt = DateTime.fromMillisecondsSinceEpoch(timestamp);

  return DateFormat('MMM yyyy').format(dt);
}

String formatCreatedAt(DateTime dateTime) {
  final formatted = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  return formatted;
}

Map<String, int> getYearStartEnd(DateTime dt) {
  final yearStart = DateTime(dt.year, 1, 1).millisecondsSinceEpoch;
  final yearEnd =
      DateTime(dt.year + 1, 0, 0, 23, 59, 59).millisecondsSinceEpoch;
  return {'start': yearStart, 'end': yearEnd};
}

Map<String, int> getMonthStartEnd(DateTime dt) {
  final monthStart = DateTime(dt.year, dt.month, 1).millisecondsSinceEpoch;
  final monthEnd =
      DateTime(dt.year, dt.month + 1, 0, 23, 59, 59).millisecondsSinceEpoch;
  return {'start': monthStart, 'end': monthEnd};
}

Map<String, int> getWeekStartEnd(DateTime dt) {
  final sunday = DateTime(
    dt.year,
    dt.month,
    dt.day,
  ).subtract(
    Duration(days: dt.weekday % 7),
  );
  final saturday = sunday.add(
    const Duration(days: 6),
  );
  final weekStart =
      DateTime(sunday.year, sunday.month, sunday.day).millisecondsSinceEpoch;
  final weekEnd =
      DateTime(saturday.year, saturday.month, saturday.day, 23, 59, 59)
          .millisecondsSinceEpoch;
  return {'start': weekStart, 'end': weekEnd};
}
