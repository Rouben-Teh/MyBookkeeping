import 'package:intl/intl.dart';

String formatDateNum(DateTime date) {
  final String yyyy = date.year.toString();
  final String mm = date.month.toString().padLeft(2, '0');
  final String dd = date.day.toString().padLeft(2, '0');

  return '$yyyy-$mm-$dd';
}

String formatStartOfTheWeek(DateTime date) {
  final startOfWeek = date.subtract(Duration(days: date.weekday));
  return '${startOfWeek.month}/${startOfWeek.day}';
}

String subsequentWeekDay(DateTime date, int day) {
  final startOfWeek = date.subtract(Duration(days: date.weekday));
  final subsequentDay = startOfWeek.add(Duration(days: day));
  return '${subsequentDay.month}/${subsequentDay.day}';
}

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

DateTime calculateNextDate(
  DateTime baseDate,
  int format,
  int totalPaymentDate,
) {
  switch (format) {
    case 0:
      return baseDate.add(Duration(days: totalPaymentDate));

    case 1:
      return baseDate.add(Duration(days: totalPaymentDate * 7));

    case 2:
      return DateTime(
        baseDate.year,
        baseDate.month + totalPaymentDate,
        baseDate.day,
      );

    default:
      return baseDate;
  }
}
