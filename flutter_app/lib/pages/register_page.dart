import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:my_bookkeeping/utils/NetUtils.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  Future<void> register() async {
    try {
      String email = emailCtrl.text;
      String password = passwordCtrl.text;
      String confirm = confirmCtrl.text;

      if (password != confirm) {
        print("两次密码不一致");
        return;
      }

      final res =
          await NetService()
          .httpPost("register", {"email": email, "password": password});

      final data = json.decode(res.body);

      if (data['id'] == null) {
        print("注册失败: ${data['error']}");
        return;
      }

      print("注册成功: $email" "id: ${data['id']}");
      Navigator.pop(context);
    } catch (e) {
      print('post error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("注册",
            style: TextStyle(
                color: Colors.white, // 设置标题文字颜色
                fontSize: 20, // 设置标题文字大小
                fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFFFF5A5A),
      ), // 设置标题文字加粗)),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailCtrl,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passwordCtrl,
              obscureText: true,
              decoration: InputDecoration(labelText: "Password"),
            ),
            TextField(
              controller: confirmCtrl,
              obscureText: true,
              decoration: InputDecoration(labelText: "Confirm Password"),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: register,
                child: Text("注册",
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
