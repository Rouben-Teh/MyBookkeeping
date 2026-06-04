import 'package:flutter/material.dart';
import 'package:my_bookkeeping/pages/home_page.dart';
import 'package:my_bookkeeping/widgets/loading_animation.dart';
import 'package:my_bookkeeping/service/api_service.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:my_bookkeeping/utils/net_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_bookkeeping/utils/app_state.dart';
import 'package:my_bookkeeping/pages/register_page.dart';
import 'package:my_bookkeeping/pages/summary_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();

  const LoginPage({Key? key}) : super(key: key);
}

class _LoginPageState extends State<LoginPage> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    emailCtrl.text = Provider.of<AppState>(context, listen: false).email;
  }

  Future<void> login() async {
    try {
      isLoading = true;

      String email = emailCtrl.text;
      String password = passwordCtrl.text;

      print('Attempting login: $email $password');

      final res = await NetService().httpPost('login',
          {'email': email, 'password': password, 'device_type': 'APP'});

      final data = json.decode(res.body);

      if (data['token'] == null) {
        print("Login failed: ${data['error']}");
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      await prefs.setString('userId', data['id'].toString());
      await prefs.setString('email', email);

      setState(() {
        Provider.of<AppState>(context, listen: false)
            .login(data['token'], data['id'].toString(), email);

        NetService().setToken(data['token']);
      });

      await APIService().fetchTransactionsAndSync();
      await APIService().fetchLocalMonthTransactions(DateTime.now());

      final dt = DateTime.now();
      setYearSummary(dt);
      setMonthSummary(dt);
      setWeekSummary(dt);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage()),
      );

      print('Attempting login: $email $password');

      isLoading = false;
    } catch (e) {
      isLoading = false;
      print('post error: $e');
    }
  }

  Widget loginWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 250,
            child: const Icon(
              Icons.account_balance_wallet,
              color: Color.fromARGB(255, 255, 79, 79),
              size: 60,
            ),
          ),
          TextField(
            controller: emailCtrl,
            decoration: InputDecoration(
              labelText: 'Email',
              focusColor: Color.fromARGB(255, 255, 79, 79),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                borderSide: BorderSide(
                    color: Color.fromARGB(255, 255, 79, 79), width: 2.0),
              ),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: passwordCtrl,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                borderSide: BorderSide(
                    color: Color.fromARGB(255, 255, 79, 79), width: 2.0),
              ),
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: login,
              child: Text('Login',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => RegisterPage()),
              );
            },
            child: Text('Don\'t have an account? Register',
                style:
                    TextStyle(color: const Color.fromARGB(255, 131, 131, 131))),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        appBar: AppBar(
          title: Text('MyBookkeeping',
              style: TextStyle(
                  color: Colors.white, // 设置标题文字颜色
                  fontSize: 20, // 设置标题文字大小
                  fontWeight: FontWeight.bold)), // 设置标题文字加粗
          backgroundColor: Color(0xFFFF5A5A), // 设置AppBar背景颜色
        ),
        body: loginWidget(context),
      ),
      if (isLoading) LoadingAnimation(),
    ]);
  }
}
