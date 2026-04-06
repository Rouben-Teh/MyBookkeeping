import 'package:flutter/material.dart';
import 'package:my_bookkeeping/pages/login_page.dart';
import 'package:provider/provider.dart';
import 'package:my_bookkeeping/pages/home_page.dart';
import 'package:my_bookkeeping/utils/app_state.dart';
import 'package:my_bookkeeping/utils/NetUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_bookkeeping/service/api_service.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // copyDatabase();
    checkLogin();
  }

  Future<void> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? userId = prefs.getString('userId');
    String? email = prefs.getString('email');

    await Future.delayed(Duration(seconds: 1)); // 可选

    if (token != null) {
      Provider.of<AppState>(context, listen: false)
          .login(token, userId ?? '', email ?? '');

      NetService().setToken(token);

      // APIService().fetchMonthTransactions(DateTime.now());
      APIService().fetchLocalMonthTransactions(DateTime.now());

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage()),
      );

      print('Logged in, Token: $token');
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginPage()),
      );

      print('Not logged in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
