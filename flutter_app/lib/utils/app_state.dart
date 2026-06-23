import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_bookkeeping/service/api_service.dart';
import 'package:my_bookkeeping/service/plan_service.dart';
import 'package:my_bookkeeping/service/summary_service.dart';
import 'package:my_bookkeeping/service/settings_service.dart';
import 'package:my_bookkeeping/utils/datetime.dart';

class AppState extends ChangeNotifier {
  //login
  bool isLoggedIn = false;
  String token = '';
  String userId = '';
  String email = '';

  //transaction
  String type = 'expense';
  List transactions = [];
  DateTime currentMonth = DateTime.now();

  //plan
  List<PlanEntry> plans = [];

  //summary
  int lastSummaryTab = 0;
  DateTime summaryYearDate = DateTime.now();
  DateTime summaryMonthDate = DateTime.now();
  DateTime summaryWeekDate = DateTime.now();
  //-year,month,week, -start -end, -list
  List<Map<String, dynamic>> summaryCache = [];

  //profile
  int streak = 0;
  int totalStreak = 0;
  int totalEntries = 0;

  //chatbot
  List messages = [];
  bool isLoading = false;

  //settings
  Color selectedColor = Colors.red;
  Color selectedLightColor = const Color.fromARGB(255, 255, 209, 206);
  String selectedCurrency = '\$';

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

  void setPlans(List data) {
    plans = (data).map((e) => PlanEntry.fromJson(e)).toList();
    _checkAutoAddPlan();
    notifyListeners();
  }

  void addPlan(PlanEntry newPlan) {
    plans.insert(0, newPlan);
    _checkAutoAddPlan();
    notifyListeners();
  }

  Future<void> _checkAutoAddPlan() async {
    final now = DateTime.now();

    for (final plan in plans) {
      if (plan.autoAddToLedger == 0) continue;

      int total = plan.intervals * plan.paidInstallments;

      DateTime next = calculateNextDate(
        DateTime.fromMillisecondsSinceEpoch(plan.timestamp),
        plan.intervalFormat,
        total,
      );

      while (next.isBefore(now)) {
        await APIService().markPlanPaid(plan, dt: next);

        total += plan.intervals;

        next = calculateNextDate(
          DateTime.fromMillisecondsSinceEpoch(plan.timestamp),
          plan.intervalFormat,
          total,
        );
      }
    }
  }

  void markPlanPaid(String id) {
    final plan = plans.firstWhere((p) => p.id == id);
    if (plan.paidInstallments < plan.installments) {
      plan.paidInstallments += 1;
    }
    notifyListeners();
  }

  void updatePlan(
    String id, {
    String? name,
    String? type,
    double? amount,
    int? installments,
    bool? fixPayment,
    int? intervalFormat,
    int? intervals,
    int? timestamp,
    bool? autoAddToLedger,
  }) {
    final plan = plans.firstWhere((p) => p.id == id);
    if (name != null) plan.name = name;
    if (type != null) plan.type = type;
    if (amount != null) plan.amount = amount;
    if (installments != null) plan.installments = installments;
    if (fixPayment != null) plan.fixPayment = fixPayment ? 1 : 0;
    if (intervalFormat != null) plan.intervalFormat = intervalFormat;
    if (intervals != null) plan.intervals = intervals;
    if (timestamp != null) plan.timestamp = timestamp;
    if (autoAddToLedger != null) plan.autoAddToLedger = autoAddToLedger ? 1 : 0;
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

  void clearSummaryCache() {
    summaryCache.clear();
  }

  void setProfileStats(int streak, int totalStreak, int totalEntries) {
    this.streak = streak;
    this.totalStreak = totalStreak;
    this.totalEntries = totalEntries;
    notifyListeners();
  }

  void clearProfileStats() {
    this.streak = 0;
    this.totalStreak = 0;
    this.totalEntries = 0;
  }

  void setMessage(List data) {
    messages = data;
    notifyListeners();
  }

  void addMessage(dynamic data) {
    messages.add(data);
    notifyListeners();
  }

  void setThemeColor(Color color, Color lightColor) {
    selectedColor = color;
    selectedLightColor = lightColor;
    notifyListeners();
  }

  void setCurrency(String currency) {
    selectedCurrency = currency;
    notifyListeners();
  }

  void setSettings(dynamic settings) {
    final parseSettings = jsonDecode(settings);
    setThemeColor(colorOptions[parseSettings['theme_color']],
        lightColorOptions[parseSettings['theme_color']]);
    setCurrency(parseSettings['currency']);
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
