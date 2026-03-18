import 'package:drift/drift.dart';
import 'package:my_bookkeeping/database/duplicate_db.dart';
import 'package:path_provider/path_provider.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:drift/native.dart';

part 'app_database.g.dart';

class Transactions extends Table {
  TextColumn get id => text()();
  IntColumn get userId => integer()();
  TextColumn get category => text()();
  RealColumn get amount => real()();
  TextColumn get note => text().nullable()();

  IntColumn get timestamp => integer()();
  TextColumn get createdAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Transactions])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // static QueryExecutor _openConnection() {
  //   return driftDatabase(
  //     name: 'bookkeeping.sqlite',
  //     native: const DriftNativeOptions(
  //       // By default, `driftDatabase` from `package:drift_flutter` stores the
  //       // database files in `getApplicationDocumentsDirectory()`.
  //       databaseDirectory: getApplicationDocumentsDirectory,
  //     ),
  //     // If you need web support, see https://drift.simonbinder.eu/platforms/web/
  //   );
  // }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final file = await copyDatabase();
    return NativeDatabase(file);
  });
}
