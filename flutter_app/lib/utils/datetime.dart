import 'package:intl/intl.dart';

String formatDate(int timestamp) {
  DateTime dt = DateTime.fromMillisecondsSinceEpoch(timestamp);

  return DateFormat('dd MMM yyyy').format(dt);
}

String formatDateMonth(int timestamp) {
  DateTime dt = DateTime.fromMillisecondsSinceEpoch(timestamp);

  return DateFormat('MMM yyyy').format(dt);
}
