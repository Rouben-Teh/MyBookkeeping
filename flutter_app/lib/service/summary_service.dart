import 'package:my_bookkeeping/utils/datetime.dart';
import 'package:my_bookkeeping/singleton/singleton.dart';
import 'package:my_bookkeeping/service/api_service.dart';

Future<void> setYearSummary(DateTime dt) async {
  final yearDt = getYearStartEnd(dt);
  final yearTransaction = await APIService()
      .fetchLocalTimeRangeTransactions(yearDt['start']!, yearDt['end']!);
  Global.appState.setSummaryCache(
      'year', yearDt['start']!, yearDt['end']!, yearTransaction);
}

Future<void> setMonthSummary(DateTime dt) async {
  final monthDt = getMonthStartEnd(dt);
  final monthTransaction = await APIService()
      .fetchLocalTimeRangeTransactions(monthDt['start']!, monthDt['end']!);
  Global.appState.setSummaryCache(
      'month', monthDt['start']!, monthDt['end']!, monthTransaction);
}

Future<void> setWeekSummary(DateTime dt) async {
  final weekDt = getWeekStartEnd(dt);
  final weekTransaction = await APIService()
      .fetchLocalTimeRangeTransactions(weekDt['start']!, weekDt['end']!);
  Global.appState.setSummaryCache(
      'week', weekDt['start']!, weekDt['end']!, weekTransaction);
}
