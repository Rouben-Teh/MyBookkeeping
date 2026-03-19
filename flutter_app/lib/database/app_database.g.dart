// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, Transaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<int> timestamp = GeneratedColumn<int>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
      'synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("synced" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _deletedMeta =
      const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
      'deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'),
      defaultValue: Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        category,
        amount,
        note,
        timestamp,
        createdAt,
        synced,
        deleted
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(Insertable<Transaction> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}timestamp'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      synced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}synced'])!,
      deleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }
}

class Transaction extends DataClass implements Insertable<Transaction> {
  final String id;
  final int userId;
  final String category;
  final double amount;
  final String? note;
  final int timestamp;
  final String createdAt;
  final bool synced;
  final bool deleted;
  const Transaction(
      {required this.id,
      required this.userId,
      required this.category,
      required this.amount,
      this.note,
      required this.timestamp,
      required this.createdAt,
      required this.synced,
      required this.deleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<int>(userId);
    map['category'] = Variable<String>(category);
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['timestamp'] = Variable<int>(timestamp);
    map['created_at'] = Variable<String>(createdAt);
    map['synced'] = Variable<bool>(synced);
    map['deleted'] = Variable<bool>(deleted);
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      userId: Value(userId),
      category: Value(category),
      amount: Value(amount),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      timestamp: Value(timestamp),
      createdAt: Value(createdAt),
      synced: Value(synced),
      deleted: Value(deleted),
    );
  }

  factory Transaction.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      category: serializer.fromJson<String>(json['category']),
      amount: serializer.fromJson<double>(json['amount']),
      note: serializer.fromJson<String?>(json['note']),
      timestamp: serializer.fromJson<int>(json['timestamp']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      synced: serializer.fromJson<bool>(json['synced']),
      deleted: serializer.fromJson<bool>(json['deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<int>(userId),
      'category': serializer.toJson<String>(category),
      'amount': serializer.toJson<double>(amount),
      'note': serializer.toJson<String?>(note),
      'timestamp': serializer.toJson<int>(timestamp),
      'createdAt': serializer.toJson<String>(createdAt),
      'synced': serializer.toJson<bool>(synced),
      'deleted': serializer.toJson<bool>(deleted),
    };
  }

  Transaction copyWith(
          {String? id,
          int? userId,
          String? category,
          double? amount,
          Value<String?> note = const Value.absent(),
          int? timestamp,
          String? createdAt,
          bool? synced,
          bool? deleted}) =>
      Transaction(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        category: category ?? this.category,
        amount: amount ?? this.amount,
        note: note.present ? note.value : this.note,
        timestamp: timestamp ?? this.timestamp,
        createdAt: createdAt ?? this.createdAt,
        synced: synced ?? this.synced,
        deleted: deleted ?? this.deleted,
      );
  Transaction copyWithCompanion(TransactionsCompanion data) {
    return Transaction(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      category: data.category.present ? data.category.value : this.category,
      amount: data.amount.present ? data.amount.value : this.amount,
      note: data.note.present ? data.note.value : this.note,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      synced: data.synced.present ? data.synced.value : this.synced,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transaction(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('category: $category, ')
          ..write('amount: $amount, ')
          ..write('note: $note, ')
          ..write('timestamp: $timestamp, ')
          ..write('createdAt: $createdAt, ')
          ..write('synced: $synced, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, category, amount, note, timestamp,
      createdAt, synced, deleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.category == this.category &&
          other.amount == this.amount &&
          other.note == this.note &&
          other.timestamp == this.timestamp &&
          other.createdAt == this.createdAt &&
          other.synced == this.synced &&
          other.deleted == this.deleted);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<String> id;
  final Value<int> userId;
  final Value<String> category;
  final Value<double> amount;
  final Value<String?> note;
  final Value<int> timestamp;
  final Value<String> createdAt;
  final Value<bool> synced;
  final Value<bool> deleted;
  final Value<int> rowid;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.category = const Value.absent(),
    this.amount = const Value.absent(),
    this.note = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.synced = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionsCompanion.insert({
    required String id,
    required int userId,
    required String category,
    required double amount,
    this.note = const Value.absent(),
    required int timestamp,
    required String createdAt,
    this.synced = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        category = Value(category),
        amount = Value(amount),
        timestamp = Value(timestamp),
        createdAt = Value(createdAt);
  static Insertable<Transaction> custom({
    Expression<String>? id,
    Expression<int>? userId,
    Expression<String>? category,
    Expression<double>? amount,
    Expression<String>? note,
    Expression<int>? timestamp,
    Expression<String>? createdAt,
    Expression<bool>? synced,
    Expression<bool>? deleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (category != null) 'category': category,
      if (amount != null) 'amount': amount,
      if (note != null) 'note': note,
      if (timestamp != null) 'timestamp': timestamp,
      if (createdAt != null) 'created_at': createdAt,
      if (synced != null) 'synced': synced,
      if (deleted != null) 'deleted': deleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionsCompanion copyWith(
      {Value<String>? id,
      Value<int>? userId,
      Value<String>? category,
      Value<double>? amount,
      Value<String?>? note,
      Value<int>? timestamp,
      Value<String>? createdAt,
      Value<bool>? synced,
      Value<bool>? deleted,
      Value<int>? rowid}) {
    return TransactionsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      timestamp: timestamp ?? this.timestamp,
      createdAt: createdAt ?? this.createdAt,
      synced: synced ?? this.synced,
      deleted: deleted ?? this.deleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<int>(timestamp.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('category: $category, ')
          ..write('amount: $amount, ')
          ..write('note: $note, ')
          ..write('timestamp: $timestamp, ')
          ..write('createdAt: $createdAt, ')
          ..write('synced: $synced, ')
          ..write('deleted: $deleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [transactions];
}

typedef $$TransactionsTableCreateCompanionBuilder = TransactionsCompanion
    Function({
  required String id,
  required int userId,
  required String category,
  required double amount,
  Value<String?> note,
  required int timestamp,
  required String createdAt,
  Value<bool> synced,
  Value<bool> deleted,
  Value<int> rowid,
});
typedef $$TransactionsTableUpdateCompanionBuilder = TransactionsCompanion
    Function({
  Value<String> id,
  Value<int> userId,
  Value<String> category,
  Value<double> amount,
  Value<String?> note,
  Value<int> timestamp,
  Value<String> createdAt,
  Value<bool> synced,
  Value<bool> deleted,
  Value<int> rowid,
});

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnFilters(column));
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnOrderings(column));
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<int> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);
}

class $$TransactionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TransactionsTable,
    Transaction,
    $$TransactionsTableFilterComposer,
    $$TransactionsTableOrderingComposer,
    $$TransactionsTableAnnotationComposer,
    $$TransactionsTableCreateCompanionBuilder,
    $$TransactionsTableUpdateCompanionBuilder,
    (
      Transaction,
      BaseReferences<_$AppDatabase, $TransactionsTable, Transaction>
    ),
    Transaction,
    PrefetchHooks Function()> {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<int> timestamp = const Value.absent(),
            Value<String> createdAt = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TransactionsCompanion(
            id: id,
            userId: userId,
            category: category,
            amount: amount,
            note: note,
            timestamp: timestamp,
            createdAt: createdAt,
            synced: synced,
            deleted: deleted,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required int userId,
            required String category,
            required double amount,
            Value<String?> note = const Value.absent(),
            required int timestamp,
            required String createdAt,
            Value<bool> synced = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TransactionsCompanion.insert(
            id: id,
            userId: userId,
            category: category,
            amount: amount,
            note: note,
            timestamp: timestamp,
            createdAt: createdAt,
            synced: synced,
            deleted: deleted,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TransactionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TransactionsTable,
    Transaction,
    $$TransactionsTableFilterComposer,
    $$TransactionsTableOrderingComposer,
    $$TransactionsTableAnnotationComposer,
    $$TransactionsTableCreateCompanionBuilder,
    $$TransactionsTableUpdateCompanionBuilder,
    (
      Transaction,
      BaseReferences<_$AppDatabase, $TransactionsTable, Transaction>
    ),
    Transaction,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
}
