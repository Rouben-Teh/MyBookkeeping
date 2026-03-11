import 'dart:convert';
import '../utils/NetUtils.dart';
import '../singleton/singleton.dart';

class APIService {
  Future<void> fetchTransactions() async {
    try {
      final res = await NetService().httpPost('list', {});
      final data = json.decode(res.body);

      if (data['transactions'] == null) {
        print("获取交易记录失败: ${data['error']}");
        return;
      }

      // print("获取交易记录成功: ${data['transactions'].length} 条");
      // print("交易记录数据: ${data['transactions']}");

      Global.appState.setTransactions(data['transactions'] ?? []);
    } catch (e) {
      print('fetch error: $e');
    }
  }

  Future<void> addTransaction(String _category, String _amount, String _note,
      DateTime date, void Function(dynamic data)? callback) async {
    final category = _category;
    final amount = double.tryParse(_amount) ?? 0.0;
    final note = _note;
    try {
      final res = await NetService().httpPost('add', {
        'id':
            '${Global.appState.userId}${DateTime.now().millisecondsSinceEpoch}',
        'category': category,
        'amount': amount,
        'note': note,
        'timestamp': date.millisecondsSinceEpoch,
      });

      final data = json.decode(res.body);

      if (data['ok'] != true) {
        print("添加失败: ${data['error']}");
        return;
      }

      APIService().fetchTransactions();

      callback?.call(data);
    } catch (e) {
      print('post error: $e');
    }
  }
}
