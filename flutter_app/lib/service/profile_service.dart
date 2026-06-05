import 'package:my_bookkeeping/singleton/singleton.dart';
import 'package:my_bookkeeping/service/api_service.dart';
import 'package:my_bookkeeping/utils/datetime.dart';

Future<void> ProfileStats() async {
  print('get profile stats');
  List streakDate = await APIService().fetchLocalTransactionStreak();
  Global.appState.setProfileStats(calculateStreak(streakDate),
      streakDate.length, await APIService().fetchLocalTransactionCount());
}

int calculateStreak(List list) {
  final Set<String> set = list.map((item) => item as String).toSet();

  int streak = 0;
  DateTime current = new DateTime.now();

  // 如果今天没记，从昨天开始
  if (!set.contains(formatDateNum(current))) {
    current = current.subtract(const Duration(days: 1));
  }

  while (set.contains(formatDateNum(current))) {
    streak++;
    current = current.subtract(const Duration(days: 1));
  }

  return streak;
}
