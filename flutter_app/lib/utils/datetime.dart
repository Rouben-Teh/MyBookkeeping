import 'package:intl/intl.dart';

String formatDate(int timestamp) {
  DateTime dt = DateTime.fromMillisecondsSinceEpoch(timestamp);

  return DateFormat("dd MMM yyyy").format(dt);
}
