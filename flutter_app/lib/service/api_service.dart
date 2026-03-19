import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:my_bookkeeping/database/app_database.dart';
import 'package:my_bookkeeping/utils/datetime.dart';
import 'package:my_bookkeeping/utils/NetUtils.dart';
import 'package:my_bookkeeping/singleton/singleton.dart';

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

  Future<void> fetchTransactionsAndSync() async {
    final res = await NetService().httpPost('list', {});
    final data = json.decode(res.body);

    final list = List<Map<String, dynamic>>.from(data['transactions']);

    for (final item in list) {
      final db = Global.appDatabase;
      await saveToDrift(db, item);
    }
  }

  Future<void> addTransaction(
      String _id,
      String _category,
      String _amount,
      String _note,
      DateTime date,
      void Function(dynamic data)? callback) async {
    final category = _category;
    final amount = double.tryParse(_amount) ?? 0.0;
    final note = _note;
    try {
      final res = await NetService().httpPost('add', {
        'id': _id,
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

      callback?.call(data);
    } catch (e) {
      print('post error: $e');
    }
  }

  Future<void> fetchMonthTransactions(DateTime dt) async {
    try {
      final dtStart = DateTime(dt.year, dt.month, 1);
      final dtEnd = DateTime(dt.year, dt.month + 1, 0, 23, 59, 59);
      final res = await NetService().httpPost('month-list', {
        'start': dtStart.millisecondsSinceEpoch,
        'end': dtEnd.millisecondsSinceEpoch
      });
      final data = json.decode(res.body);

      if (data['transactions'] == null) {
        print("获取交易记录失败: ${data['error']}");
        return;
      }

      Global.appState.setTransactions(data['transactions'] ?? []);
    } catch (e) {
      print('fetch error: $e');
    }
  }

  Future<void> fetchLocalMonthTransactions(DateTime dt) async {
    try {
      final dtStart = DateTime(dt.year, dt.month, 1).millisecondsSinceEpoch;
      final dtEnd =
          DateTime(dt.year, dt.month + 1, 0, 23, 59, 59).millisecondsSinceEpoch;

      final db = Global.appDatabase;
      final query = db.select(db.transactions)
        ..where((t) => t.timestamp.isBetweenValues(dtStart, dtEnd))
        ..orderBy([
          (t) => OrderingTerm(expression: t.timestamp, mode: OrderingMode.desc),
        ]);
      final list = await query.get();
      print('list:$list');
      final jsonList = list.map((row) => row.toJson()).toList();
      Global.appState.setTransactions(jsonList);
    } catch (e) {
      print('fetch error: $e');
    }
  }

  Future<void> addLocalTransaction(
      String _category,
      String _amount,
      String _note,
      DateTime date,
      void Function(dynamic data)? callback) async {
    final _id =
        '${Global.appState.userId}${DateTime.now().millisecondsSinceEpoch}';
    final item = {
      'id': _id,
      'user_id': int.parse(Global.appState.userId),
      'category': _category,
      'amount': double.tryParse(_amount) ?? 0.0,
      'note': _note,
      'timestamp': date.millisecondsSinceEpoch,
      'created_at': formatCreatedAt(date),
      'synced': 0,
      'deleted': 0,
    };
    final db = Global.appDatabase;

    await saveToDrift(db, item);

    await fetchLocalMonthTransactions(Global.appState.currentMonth);

    await addTransaction(_id, _category, _amount, _note, date, (data) async {
      await (db.update(db.transactions)
            ..where((t) => t.id.equals(t.id.toString())))
          .write(
        TransactionsCompanion(
          synced: Value(true),
        ),
      );
    });

    callback?.call(null);
  }

  Future<void> syncUnsyncTransactions() async {
    final db = Global.appDatabase;
    final list = await (db.select(db.transactions)
          ..where((t) => t.synced.equals(false)))
        .get();
    for (final t in list) {
      try {
        final res = await NetService().httpPost('sync', {
          'id': t.id,
          'category': t.category,
          'amount': t.amount,
          'note': t.note,
          'timestamp': t.timestamp,
        });

        final data = json.decode(res.body);

        if (data['ok'] != true) {
          print("同步失败: ${data['error']}");
          return;
        }

        await (db.update(db.transactions)
              ..where((t) => t.id.equals(t.id.toString())))
            .write(
          TransactionsCompanion(
            synced: Value(true),
          ),
        );
      } catch (e) {
        print('同步失败: $e');
      }
    }
  }
}
