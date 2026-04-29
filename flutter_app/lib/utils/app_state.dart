import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  bool isLoggedIn = false;
  String token = '';
  String userId = '';
  String email = '';

  List transactions = [];

  List messages = [];

  DateTime currentMonth = DateTime.now();

  void login(String _token, String _userId, String _email) {
    token = _token;
    userId = _userId;
    email = _email;
    isLoggedIn = true;
    notifyListeners();
    print('Logged in $userId $email $isLoggedIn');
  }

  void logout() {
    token = "";
    userId = "";
    email = "";
    isLoggedIn = false;
    notifyListeners();
    print('Logged out $userId $email $isLoggedIn');
  }

  void setTransactions(List data) {
    transactions = data;
    print('Transaction records updated: ${transactions}');
    notifyListeners(); // 通知所有UI刷新
  }

  void setCurrentMonth(DateTime dt) {
    currentMonth = dt;
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

  void checkVariables() {
    print(
        'Current user status: isLoggedIn=$isLoggedIn, token=$token, userId=$userId, email=$email, transactions=${transactions.length}, data: ${transactions}');
  }
}
