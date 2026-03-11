import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  bool isLoggedIn = false;
  String token = "";
  String userId = "";
  String email = "";

  List transactions = [];

  DateTime currentMonth = DateTime.now();

  void login(String _token, String _userId, String _email) {
    token = _token;
    userId = _userId;
    email = _email;
    isLoggedIn = true;
    notifyListeners();
    print("用户登录状态已更新: $userId $email $isLoggedIn");
  }

  void logout() {
    token = "";
    userId = "";
    email = "";
    isLoggedIn = false;
    notifyListeners();
    print("用户登录状态已更新: $isLoggedIn");
  }

  void setTransactions(List data) {
    transactions = data;
    print("交易记录已更新: ${transactions}");
    notifyListeners(); // 通知所有UI刷新
  }

  void setCurrentMonth(DateTime dt) {
    currentMonth = dt;
    notifyListeners();
  }

  void checkVariables() {
    print(
        "当前用户状态: isLoggedIn=$isLoggedIn, token=$token, userId=$userId, email=$email, transactions=${transactions.length} 条, 数据: ${transactions}");
  }
}
