import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'home_page.dart';
import '../utils/app_state.dart';
import '../utils/NetUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  Future<void> fetchTransactions() async {
    try {
      final res = await NetService().httpPost('list', {});
      final data = json.decode(res.body);

      if (data['transactions'] == null) {
        print("获取交易记录失败: ${data['error']}");
        return;
      }

      setState(() => Provider.of<AppState>(context, listen: false)
          .setTransactions(data['transactions'] ?? []));
    } catch (e) {
      print('fetch error: $e');
    }
  }

  Future<void> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    String? userId = prefs.getString("userId");
    String? email = prefs.getString("email");

    await Future.delayed(Duration(seconds: 1)); // 可选

    if (token != null) {
      Provider.of<AppState>(context, listen: false)
          .login(token, userId ?? "", email ?? "");

      NetService().setToken(token);

      print("已登录，Token: $token");
    }

    fetchTransactions();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
