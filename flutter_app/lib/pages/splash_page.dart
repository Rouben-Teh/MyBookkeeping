import 'package:flutter/material.dart';
import 'package:my_bookkeeping/pages/login_page.dart';
import 'package:my_bookkeeping/singleton/singleton.dart';
import 'package:provider/provider.dart';
import 'package:my_bookkeeping/pages/home_page.dart';
import 'package:my_bookkeeping/service/summary_service.dart';
import 'package:my_bookkeeping/utils/app_state.dart';
import 'package:my_bookkeeping/utils/net_utils.dart';
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
      NetService().setToken(token);

      final appState = Provider.of<AppState>(context, listen: false);

      final res = await APIService().validation();
      if (res != null && !res['ok']) {
        if (res['reason'] == 'revoked') {
          final prefs = await SharedPreferences.getInstance();

          NetService().setToken('');

          appState.setTransactions([]);
          appState.setPlans([]);
          appState.clearSummaryCache();
          appState.clearProfileStats();
          appState.setMessage([]);

          await prefs.remove('token');
          await prefs.remove('userId');
          await prefs.remove('email');

          final db = Global.appDatabase;
          await db.delete(db.transactions).go(); // 清空表

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => LoginPage()),
          );
          return;
        }
      }

      if (res != null && res['token'] != null) {
        print('token renew: ${res['token']}');
        NetService().setToken('');
        token = res['token'];
        NetService().setToken(token!);
        await prefs.setString('token', token);
      }

      if (res == null || !res['ok']) {
        if (res == null || res['reason'] == 'Server offline') {
          //TODO: show offline notification if want
        }
      }

      // print('res: ? $res');

      appState.login(token, userId ?? '', email ?? '');

      // APIService().fetchMonthTransactions(DateTime.now());
      await APIService().fetchLocalMonthTransactions(DateTime.now());
      await APIService().fetchLocalPlans();
      await APIService().fetchLocalSettings();

      APIService().syncUnsyncTransactions();
      APIService().syncUnsyncPlans();
      APIService().syncUnsyncSettings();

      //summary
      final dt = DateTime.now();
      setYearSummary(dt);
      setMonthSummary(dt);
      setWeekSummary(dt);

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
