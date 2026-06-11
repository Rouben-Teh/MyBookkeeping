import 'package:flutter/material.dart';
import 'package:my_bookkeeping/singleton/singleton.dart';
import 'dart:convert';
import 'package:my_bookkeeping/utils/net_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ContactPage extends StatefulWidget {
  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final messageCtrl = TextEditingController();
  bool isEmpty = false;

  Future<void> submit() async {
    try {
      if (!messageCtrl.text.isNotEmpty) {
        setState(() {
          isEmpty = true;
        });
        return;
      }

      setState(() {
        isEmpty = false;
      });

      final res = await NetService().httpPost('contact', {
        'device_type': 'APP',
        'name': Global.appState.userId,
        'email': Global.appState.email,
        'message': messageCtrl.text
      });

      final data = json.decode(res.body);

      if (data['ok']) {
        Fluttertoast.showToast(
          msg: 'Message sent successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        Navigator.pop(context);
      }
    } catch (e) {
      print('post error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback',
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFFFF5A5A),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(
                height: 200,
                child: TextField(
                  controller: messageCtrl,
                  minLines: null,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    hintText: 'Input feedback here',
                    errorText: isEmpty ? 'Please enter a message' : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                )),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: submit,
                child: Text('Submit',
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
