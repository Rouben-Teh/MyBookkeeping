import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:my_bookkeeping/database/app_database.dart';
import 'package:my_bookkeeping/utils/datetime.dart';
import 'package:my_bookkeeping/utils/net_utils.dart';
import 'package:my_bookkeeping/singleton/singleton.dart';
import 'package:my_bookkeeping/pages/profile_page.dart';

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

    ProfileStats();
  }

  Future<void> addTransaction(
      String _id,
      String _type,
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
        'type': _type,
        'category': category,
        'amount': amount,
        'note': note,
        'timestamp': date.millisecondsSinceEpoch,
      });

      final data = json.decode(res.body);

      if (data['ok'] != true) {
        print("Adding transaction failed: ${data['error']}");
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
        print("Fetching transaction records failed: ${data['error']}");
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

  Future<dynamic> fetchLocalTimeRangeTransactions(int start, int end) async {
    try {
      print('year start: ' + start.toString() + '-' + end.toString());

      final db = Global.appDatabase;
      final query = db.select(db.transactions)
        ..where((t) => t.timestamp.isBetweenValues(start, end))
        ..where((t) => t.deleted.equals(false))
        ..orderBy([
          (t) => OrderingTerm(expression: t.timestamp, mode: OrderingMode.desc),
        ]);
      final list = await query.get();
      // print('time range list:$list');
      final jsonList = list.map((row) => row.toJson()).toList();
      return jsonList;
    } catch (e) {
      print('fetch error: $e');
    }
  }

  Future<List> fetchLocalTransactionStreak() async {
    try {
      final db = Global.appDatabase;
      final result = await db.customSelect(
        '''
        SELECT DISTINCT DATE(created_at) as day
        FROM transactions 
        WHERE deleted != 1 
        ORDER BY day DESC
        ''',
      ).get();

      final days = result.map((row) {
        return row.read<String>('day');
      }).toList();
      // print('streak: ' + days.toString());
      return days;
    } catch (e) {
      print('fetch error: $e');
      return [];
    }
  }

  Future<int> fetchLocalTransactionCount() async {
    try {
      final db = Global.appDatabase;
      final countExp = db.transactions.id.count();

      final query = db.selectOnly(db.transactions)
        ..addColumns([countExp])
        ..where(db.transactions.deleted.equals(false));

      final result = await query.getSingle();

      final totalEntries = result.read(countExp) ?? 0;
      return totalEntries;
    } catch (e) {
      print('fetch error: $e');
      return 0;
    }
  }

  Future<void> addLocalTransaction(
      String _type,
      String _category,
      String _amount,
      String _note,
      DateTime date,
      void Function(dynamic data)? callback) async {
    final _id =
        '${Global.appState.userId}${DateTime.now().millisecondsSinceEpoch}';
    final item = {
      'id': _id,
      'type': _type,
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

    addTransaction(_id, _type, _category, _amount, _note, date, (data) async {
      await (db.update(db.transactions)..where((t) => t.id.equals(_id))).write(
        TransactionsCompanion(
          synced: Value(true),
        ),
      );
    });

    Global.appState
        .addSummaryTransactions('week', date.millisecondsSinceEpoch, item);
    Global.appState
        .addSummaryTransactions('month', date.millisecondsSinceEpoch, item);
    Global.appState
        .addSummaryTransactions('year', date.millisecondsSinceEpoch, item);
    ProfileStats();

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
          'type': l.type,
          'category': l.category,
          'amount': l.amount,
          'note': l.note,
          'timestamp': l.timestamp,
          'synced': 1,
          'deleted': l.deleted
        });

        final data = json.decode(res.body);

        if (data['ok'] != true) {
          print("Syncing transaction failed: ${data['error']}");
          return;
        }

        await (db.update(db.transactions)..where((t) => t.id.equals(l.id)))
            .write(
          TransactionsCompanion(
            synced: Value(true),
          ),
        );
        print('Synced successfully');
      } catch (e) {
        print('Syncing failed: $e');
      }
    }
  }

  Future<void> markDeleteLocalTransactions(dynamic data, bool value) async {
    final db = Global.appDatabase;
    await (db.update(db.transactions)..where((t) => t.id.equals(data['id'])))
        .write(
      TransactionsCompanion(
        synced: Value(false),
        deleted: Value(value),
      ),
    );

    fetchLocalMonthTransactions(Global.appState.currentMonth);

    if (value) {
      Global.appState
          .removeSummaryTransactions('week', data['timestamp'], data);
      Global.appState
          .removeSummaryTransactions('month', data['timestamp'], data);
      Global.appState
          .removeSummaryTransactions('year', data['timestamp'], data);
    } else {
      Global.appState.addSummaryTransactions('week', data['timestamp'], data);
      Global.appState.addSummaryTransactions('month', data['timestamp'], data);
      Global.appState.addSummaryTransactions('year', data['timestamp'], data);
    }

    ProfileStats();
  }

  Future<void> editLocalTransactions(
      dynamic data, void Function(dynamic data)? callback) async {
    final db = Global.appDatabase;
    await (db.update(db.transactions)..where((t) => t.id.equals(data['id'])))
        .write(
      TransactionsCompanion(
        id: Value(data['id']),
        type: Value(data['type']),
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

    Global.appState.updateSummaryTransactions('week', data['timestamp']);
    Global.appState.updateSummaryTransactions('month', data['timestamp']);
    Global.appState.updateSummaryTransactions('year', data['timestamp']);

    callback?.call(null);
  }

  Future<String> chat(String message) async {
    try {
      final res = await NetService().httpPost('chat', {
        'message': message,
      });

      final data = json.decode(res.body);

      print(data);

      if (!data['ok']) throw new Error();

      final jsonData = json.decode(data['response']);

      if (jsonData['type'] == 'tool') {
        if (jsonData['tool']['name'] == 'add_expense' ||
            jsonData['tool']['name'] == 'add_income') {
          fetchTransactionsAndSync();
        }
      }

      return jsonData['content'];
    } catch (e) {
      print('fetch error: $e');
      return 'Network error';
    }
  }

  Future<List<dynamic>> getChatHistory() async {
    try {
      final res = await NetService().httpPost('get_chat_history', {});

      final data = json.decode(res.body);

      print(data);

      if (!data['ok']) throw new Error();

      if (data['response']['chat_history'] != null) {
        return data['response']['chat_history'];
      }
      return [];
    } catch (e) {
      print('fetch error: $e');
      return [];
    }
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
  //       print("Deleting transaction failed: ${data['error']}");
  //       return;
  //     }
  //   } catch (e) {
  //     print('Deleting transaction failed: $e');
  //   }
  // }
}
