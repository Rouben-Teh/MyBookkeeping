import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_state.dart';

class RecordDetailsPage extends StatefulWidget {
  @override
  _RecordDetailsPageState createState() => _RecordDetailsPageState();
}

class _RecordDetailsPageState extends State<RecordDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('记账',
            style: TextStyle(
                color: Colors.white, // 设置标题文字颜色
                fontSize: 20, // 设置标题文字大小
                fontWeight: FontWeight.bold)), // 设置标题文字加粗
        backgroundColor: Color(0xFFFF5A5A), // 设置AppBar背景颜色
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: Provider.of<AppState>(context, listen: false)
                    .transactions
                    .length,
                itemBuilder: (context, i) {
                  final t = Provider.of<AppState>(context, listen: false)
                      .transactions[i];
                  return ListTile(
                    title: Text('¥${t['amount']}'),
                    subtitle: Text(t['note'] ?? ''),
                    trailing: Text(t['created_at'] ?? ''),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
