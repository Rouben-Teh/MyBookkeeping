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
      await saveToDrift(item);
    }

    fetchLocalMonthTransactions(Global.appState.currentMonth);
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
        ..where((t) => t.deleted.equals(false))
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

    await saveToDrift(item);

    await fetchLocalMonthTransactions(Global.appState.currentMonth);

    addTransaction(_id, _category, _amount, _note, date, (data) async {
      await (db.update(db.transactions)..where((t) => t.id.equals(_id))).write(
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
    for (final l in list) {
      try {
        final res = await NetService().httpPost('sync', {
          'id': l.id,
          'category': l.category,
          'amount': l.amount,
          'note': l.note,
          'timestamp': l.timestamp,
          'synced': 1,
          'deleted': l.deleted
        });

        final data = json.decode(res.body);

        if (data['ok'] != true) {
          print("同步失败: ${data['error']}");
          return;
        }

        await (db.update(db.transactions)..where((t) => t.id.equals(l.id)))
            .write(
          TransactionsCompanion(
            synced: Value(true),
          ),
        );
        print('synced successfully');
      } catch (e) {
        print('同步失败: $e');
      }
    }
  }

  Future<void> markDeleteLocalTransactions(String id, bool value) async {
    final db = Global.appDatabase;
    await (db.update(db.transactions)..where((t) => t.id.equals(id))).write(
      TransactionsCompanion(
        synced: Value(false),
        deleted: Value(value),
      ),
    );

    fetchLocalMonthTransactions(Global.appState.currentMonth);
  }

  Future<void> editLocalTransactions(
      dynamic data, void Function(dynamic data)? callback) async {
    final db = Global.appDatabase;
    await (db.update(db.transactions)..where((t) => t.id.equals(data['id'])))
        .write(
      TransactionsCompanion(
        id: Value(data['id']),
        category: Value(data['category']),
        amount: Value(data['amount']),
        note: Value(data['note']),
        timestamp: Value(data['timestamp']),
        createdAt: Value(data['created_at']),
        synced: Value(false),
        deleted: Value(false),
      ),
    );

    await fetchLocalMonthTransactions(Global.appState.currentMonth);

    syncUnsyncTransactions();

    callback?.call(null);
  }

  // Future<void> deleteLocalTransactions(String id) async {
  //   final db = Global.appDatabase;
  //   await (db.delete(db.transactions)..where((t) => t.id.equals(id))).go();
  // }

  // Future<void> deleteTransactions(String id) async {
  //   try {
  //     final res = await NetService().httpPost('delete', {
  //       'id': id,
  //     });
  //     final data = json.decode(res.body);

  //     if (data['ok'] != true) {
  //       print("删除失败: ${data['error']}");
  //       return;
  //     }
  //   } catch (e) {
  //     print('删除失败: $e');
  //   }
  // }
}
