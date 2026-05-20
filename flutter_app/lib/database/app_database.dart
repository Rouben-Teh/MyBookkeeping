import 'package:drift/drift.dart';
import 'package:my_bookkeeping/singleton/singleton.dart';
import 'package:path_provider/path_provider.dart';
import 'package:drift/native.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';

part 'app_database.g.dart';

class Transactions extends Table {
  TextColumn get id => text()();
  IntColumn get userId => integer()();
  TextColumn get type => text()();
  TextColumn get category => text()();
  RealColumn get amount => real()();
  TextColumn get note => text().nullable()();

  IntColumn get timestamp => integer()();
  TextColumn get createdAt => text()();

  BoolColumn get synced => boolean().withDefault(Constant(false))();
  BoolColumn get deleted => boolean().withDefault(Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Transactions])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    print('DB Path: ${dbFolder}');
    final file = File(join(dbFolder.path, 'bookkeeping.sqlite'));
    // if (!await file.exists()) {
    //   try {
    //     final copyFile = await copyDatabase(file);
    //     return NativeDatabase(copyFile);
    //   } catch (e) {
    //     return NativeDatabase(file);
    //   }
    // }
    return NativeDatabase(file);
  });
}

Future<File> copyDatabase(File file) async {
  if (!await file.exists()) {
    print('no sqlite file');
    final data = await rootBundle.load('assets/bookkeeping.sqlite');
    final bytes = data.buffer.asUint8List();
    await file.writeAsBytes(bytes);
  } else {
    print('yes sqlite file');
  }

  return file;
}

Future<void> saveToDrift(dynamic item) async {
  final db = Global.appDatabase;
  print('data to save: $item');
  await db.into(db.transactions).insertOnConflictUpdate(
        TransactionsCompanion(
          id: Value(item['id']),
          userId: Value(item['user_id']),
          type: Value(item['type']),
          category: Value(item['category']),
          amount: Value((item['amount'] as num).toDouble()),
          note: Value(item['note'] ?? ''),
          timestamp: Value(item['timestamp']),
          createdAt: Value(item['created_at']),
          synced: Value(item['synced'] == 1),
          deleted: Value(item['deleted'] == 1),
        ),
      );
}
