import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  bool isLoggedIn = false;
  String token = "";
  String userId = "";
  String email = "";

  List transactions = [];

  void login(String _token, String _userId, String _email) {
    token = _token;
    userId = _userId;
    email = _email;
    isLoggedIn = true;
    notifyListeners();
    print("用户登录状态已更新: $isLoggedIn");
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
    notifyListeners(); // 通知所有UI刷新
  }
}
