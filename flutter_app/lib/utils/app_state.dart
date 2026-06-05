import 'package:flutter/material.dart';
import 'package:my_bookkeeping/service/plan_service.dart';
import 'package:my_bookkeeping/service/summary_service.dart';

class AppState extends ChangeNotifier {
  bool isLoggedIn = false;
  String token = '';
  String userId = '';
  String email = '';

  String type = 'expense';

  List transactions = [];

  List messages = [];

  bool isLoading = false;

  List<PlanEntry> plans = [
    PlanEntry(
      id: 'userId0',
      userId: 0,
      name: 'iPhone 14 分期付款',
      direction: PlanDirection.expense,
      totalAmount: 6999,
      totalInstallments: 12,
      fixPayment: true,
      intervalFormat: 2,
      intervals: 30,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      paidInstallments: 3,
      autoAddToLedger: true,
    ),
    PlanEntry(
      id: 'userId1',
      userId: 0,
      name: '借给小王',
      direction: PlanDirection.income,
      totalAmount: 3000,
      totalInstallments: 6,
      fixPayment: false,
      intervalFormat: 2,
      intervals: 30,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      paidInstallments: 1,
      autoAddToLedger: false,
    ),
  ];

  DateTime currentMonth = DateTime.now();

  int lastSummaryTab = 0;
  DateTime summaryYearDate = DateTime.now();
  DateTime summaryMonthDate = DateTime.now();
  DateTime summaryWeekDate = DateTime.now();
  List<Map<String, dynamic>> summaryCache =
      []; //-year,month,week, -start -end, -list

  int streak = 0;
  int totalStreak = 0;
  int totalEntries = 0;

  void login(String _token, String _userId, String _email) {
    token = _token;
    userId = _userId;
    email = _email;
    isLoggedIn = true;
    notifyListeners();
    print('Logged in $userId $email $isLoggedIn');
  }

  void logout() {
    token = '';
    userId = '';
    email = '';
    isLoggedIn = false;
    notifyListeners();
    print('Logged out $userId $email $isLoggedIn');
  }

  void setType(String t) {
    type = t;
    notifyListeners();
  }

  void setTransactions(List data) {
    transactions = data;
    print('Transaction records updated: ${transactions}');
    notifyListeners(); // 通知所有UI刷新
  }

  void addPlan(
      String name,
      PlanDirection direction,
      double totalAmount,
      int totalInstallments,
      bool fixPayment,
      int intervalFormat,
      int intervals,
      int timestamp,
      bool autoAddToLedger) {
    plans.insert(
        0,
        PlanEntry(
          id: '${userId}${DateTime.now().millisecondsSinceEpoch}',
          userId: int.parse(userId),
          name: name.trim(),
          direction: direction,
          totalAmount: totalAmount,
          totalInstallments: totalInstallments,
          fixPayment: fixPayment,
          intervalFormat: intervalFormat,
          intervals: intervals,
          timestamp: timestamp,
          autoAddToLedger: autoAddToLedger,
        ));
    notifyListeners();
  }

  void markPlanPaid(String id) {
    final plan = plans.firstWhere((p) => p.id == id);
    if (plan.paidInstallments < plan.totalInstallments) {
      plan.paidInstallments += 1;
    }
    notifyListeners();
  }

  void updatePlan(
    String id, {
    String? name,
    PlanDirection? direction,
    double? totalAmount,
    int? totalInstallments,
    bool? fixPayment,
    int? intervalFormat,
    int? intervals,
    int? timestamp,
    bool? autoAddToLedger,
  }) {
    final plan = plans.firstWhere((p) => p.id == id);
    if (name != null) plan.name = name;
    if (direction != null) plan.direction = direction;
    if (totalAmount != null) plan.totalAmount = totalAmount;
    if (totalInstallments != null) plan.totalInstallments = totalInstallments;
    if (fixPayment != null) plan.fixPayment = fixPayment;
    if (intervalFormat != null) plan.intervalFormat = intervalFormat;
    if (intervals != null) plan.intervals = intervals;
    if (timestamp != null) plan.timestamp = timestamp;
    if (autoAddToLedger != null) plan.autoAddToLedger = autoAddToLedger;
    notifyListeners();
  }

  void removePlan(String id) {
    plans.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  void setSummaryCache(String key, int start, int end, dynamic transaction) {
    final index = summaryCache.indexWhere(
      (e) => e['key'] == key,
    );

    final data = {
      'key': key,
      'start': start,
      'end': end,
      'transaction': transaction,
    };

    if (index != -1) {
      summaryCache[index] = data;
    } else {
      summaryCache.add(data);
    }

    notifyListeners();
  }

  void setLastSummaryTab(int index) {
    lastSummaryTab = index;
  }

  void setCurrentMonth(DateTime dt) {
    currentMonth = dt;
    notifyListeners();
  }

  void addSummaryTransactions(String key, int timestamp, dynamic data) {
    final index = summaryCache.indexWhere(
      (e) => e['key'] == key,
    );

    if (index != -1) {
      int start = summaryCache[index]['start'];
      int end = summaryCache[index]['end'];
      if (timestamp >= start && timestamp <= end) {
        final transactions = summaryCache[index]['transaction'] as List;
        transactions.add(data);
        // print('added $key summary');
        notifyListeners();
      }
    }
  }

  void removeSummaryTransactions(String key, int timestamp, dynamic data) {
    final index = summaryCache.indexWhere(
      (e) => e['key'] == key,
    );

    if (index != -1) {
      int start = summaryCache[index]['start'];
      int end = summaryCache[index]['end'];
      if (timestamp >= start && timestamp <= end) {
        final transactions = summaryCache[index]['transaction'] as List;
        final txIndex = transactions.indexWhere((e) => e['id'] == data['id']);

        if (txIndex != -1) {
          transactions[txIndex]['deleted'] = 1;
          // print('remove $key summary');
          notifyListeners();
        }
      }
    }
  }

  void updateSummaryTransactions(String key, int timestamp) {
    final index = summaryCache.indexWhere(
      (e) => e['key'] == key,
    );

    if (index != -1) {
      int start = summaryCache[index]['start'];
      int end = summaryCache[index]['end'];
      if (timestamp >= start && timestamp <= end) {
        switch (key) {
          case 'year':
            setYearSummary(summaryYearDate);
            // print('update year summary');
            break;
          case 'month':
            setMonthSummary(summaryMonthDate);
            // print('update month summary');
            break;
          case 'week':
            setWeekSummary(summaryWeekDate);
            // print('update week summary');
            break;
        }
        notifyListeners();
      }
    }
  }

  void setProfileStats(int streak, int totalStreak, int totalEntries) {
    this.streak = streak;
    this.totalStreak = totalStreak;
    this.totalEntries = totalEntries;
    notifyListeners();
  }

  void setMessage(List data) {
    messages = data;
    notifyListeners();
  }

  void addMessage(dynamic data) {
    messages.add(data);
    notifyListeners();
  }

  void setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  void checkVariables() {
    print(
        'Current user status: isLoggedIn=$isLoggedIn, token=$token, userId=$userId, email=$email, transactions=${transactions.length}, data: ${transactions}');
  }
}
