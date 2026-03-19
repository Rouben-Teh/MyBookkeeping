import 'package:flutter/material.dart';
import 'package:my_bookkeeping/pages/home_page.dart';
import 'package:my_bookkeeping/service/api_service.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import '../utils/NetUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_state.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();

  const LoginPage({Key? key}) : super(key: key);
}

class _LoginPageState extends State<LoginPage> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    emailCtrl.text = Provider.of<AppState>(context, listen: false).email;
  }

  Future<void> login() async {
    try {
      String email = emailCtrl.text;
      String password = passwordCtrl.text;

      print('尝试登录: $email $password');

      final res = await NetService()
          .httpPost('login', {'email': email, 'password': password});

      final data = json.decode(res.body);

      if (data['token'] == null) {
        print("登录失败: ${data['error']}");
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

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage()),
      );

      print('登录: $email $password');
    } catch (e) {
      print('post error: $e');
    }
  }

  Widget loginWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          TextField(
            controller: emailCtrl,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          TextField(
            controller: passwordCtrl,
            obscureText: true,
            decoration: InputDecoration(labelText: 'Password'),
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
              child: Text('登录',
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
            child: Text('没有账号？注册'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('个人资料',
            style: TextStyle(
                color: Colors.white, // 设置标题文字颜色
                fontSize: 20, // 设置标题文字大小
                fontWeight: FontWeight.bold)), // 设置标题文字加粗
        backgroundColor: Color(0xFFFF5A5A), // 设置AppBar背景颜色
      ),
      body: loginWidget(context),
    );
  }
}
