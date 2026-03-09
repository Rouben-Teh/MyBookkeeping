import 'package:flutter/material.dart';
import 'package:my_bookkeeping/pages/login_page.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import '../utils/NetUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_state.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();

  const ProfilePage({Key? key}) : super(key: key);
}

class _ProfilePageState extends State<ProfilePage> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    emailCtrl.text = Provider.of<AppState>(context, listen: false).email;
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final res = await NetService().httpPost("logout", {});

      final data = json.decode(res.body);

      if (data['ok'] != true) {
        print("登出失败: ${data['error']}");
        // return;
      } else {
        print("登出成功");
      }

      await prefs.remove('token');
      await prefs.remove('userId');
      await prefs.remove('email');

      setState(() {
        emailCtrl.clear();
        passwordCtrl.clear();
        Provider.of<AppState>(context, listen: false).logout();
        NetService().setToken("");
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginPage()),
      );
    } catch (e) {
      print('logout error: $e');
    }
  }

  Widget profileWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 用户ID显示
          Text(
            "用户ID:",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          SizedBox(height: 5),

          Text(
            emailCtrl.text,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 40),

          // 登出按钮
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: () {
                logout();
              },
              child: Text("登出",
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),

          // Bug check button (临时)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: () {
                Provider.of<AppState>(context, listen: false).checkVariables();
              },
              child: Text("Check",
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("个人资料",
            style: TextStyle(
                color: Colors.white, // 设置标题文字颜色
                fontSize: 20, // 设置标题文字大小
                fontWeight: FontWeight.bold)), // 设置标题文字加粗
        backgroundColor: Color(0xFFFF5A5A), // 设置AppBar背景颜色
      ),
      body: profileWidget(context),
    );
  }
}
