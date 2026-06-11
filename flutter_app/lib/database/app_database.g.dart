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
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
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
        type,
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
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
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
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
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
  final String type;
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
      required this.type,
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
    map['type'] = Variable<String>(type);
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
      type: Value(type),
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
      type: serializer.fromJson<String>(json['type']),
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
      'type': serializer.toJson<String>(type),
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
          String? type,
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
        type: type ?? this.type,
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
      type: data.type.present ? data.type.value : this.type,
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
          ..write('type: $type, ')
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
  int get hashCode => Object.hash(id, userId, type, category, amount, note,
      timestamp, createdAt, synced, deleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.type == this.type &&
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
  final Value<String> type;
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
    this.type = const Value.absent(),
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
    required String type,
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
        type = Value(type),
        category = Value(category),
        amount = Value(amount),
        timestamp = Value(timestamp),
        createdAt = Value(createdAt);
  static Insertable<Transaction> custom({
    Expression<String>? id,
    Expression<int>? userId,
    Expression<String>? type,
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
      if (type != null) 'type': type,
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
      Value<String>? type,
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
      type: type ?? this.type,
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
    if (type.present) {
      map['type'] = Variable<String>(type.value);
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
          ..write('type: $type, ')
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

class $PlansTable extends Plans with TableInfo<$PlansTable, Plan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlansTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _installmentsMeta =
      const VerificationMeta('installments');
  @override
  late final GeneratedColumn<int> installments = GeneratedColumn<int>(
      'installments', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _fixPaymentMeta =
      const VerificationMeta('fixPayment');
  @override
  late final GeneratedColumn<bool> fixPayment = GeneratedColumn<bool>(
      'fix_payment', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("fix_payment" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _intervalFormatMeta =
      const VerificationMeta('intervalFormat');
  @override
  late final GeneratedColumn<int> intervalFormat = GeneratedColumn<int>(
      'interval_format', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _intervalsMeta =
      const VerificationMeta('intervals');
  @override
  late final GeneratedColumn<int> intervals = GeneratedColumn<int>(
      'intervals', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<int> timestamp = GeneratedColumn<int>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _autoAddToLedgerMeta =
      const VerificationMeta('autoAddToLedger');
  @override
  late final GeneratedColumn<bool> autoAddToLedger = GeneratedColumn<bool>(
      'auto_add_to_ledger', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("auto_add_to_ledger" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _paidInstallmentsMeta =
      const VerificationMeta('paidInstallments');
  @override
  late final GeneratedColumn<int> paidInstallments = GeneratedColumn<int>(
      'paid_installments', aliasedName, false,
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
        name,
        type,
        amount,
        installments,
        fixPayment,
        intervalFormat,
        intervals,
        timestamp,
        autoAddToLedger,
        paidInstallments,
        createdAt,
        synced,
        deleted
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'plans';
  @override
  VerificationContext validateIntegrity(Insertable<Plan> instance,
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
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('installments')) {
      context.handle(
          _installmentsMeta,
          installments.isAcceptableOrUnknown(
              data['installments']!, _installmentsMeta));
    } else if (isInserting) {
      context.missing(_installmentsMeta);
    }
    if (data.containsKey('fix_payment')) {
      context.handle(
          _fixPaymentMeta,
          fixPayment.isAcceptableOrUnknown(
              data['fix_payment']!, _fixPaymentMeta));
    }
    if (data.containsKey('interval_format')) {
      context.handle(
          _intervalFormatMeta,
          intervalFormat.isAcceptableOrUnknown(
              data['interval_format']!, _intervalFormatMeta));
    } else if (isInserting) {
      context.missing(_intervalFormatMeta);
    }
    if (data.containsKey('intervals')) {
      context.handle(_intervalsMeta,
          intervals.isAcceptableOrUnknown(data['intervals']!, _intervalsMeta));
    } else if (isInserting) {
      context.missing(_intervalsMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('auto_add_to_ledger')) {
      context.handle(
          _autoAddToLedgerMeta,
          autoAddToLedger.isAcceptableOrUnknown(
              data['auto_add_to_ledger']!, _autoAddToLedgerMeta));
    }
    if (data.containsKey('paid_installments')) {
      context.handle(
          _paidInstallmentsMeta,
          paidInstallments.isAcceptableOrUnknown(
              data['paid_installments']!, _paidInstallmentsMeta));
    } else if (isInserting) {
      context.missing(_paidInstallmentsMeta);
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
  Plan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Plan(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      installments: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}installments'])!,
      fixPayment: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}fix_payment'])!,
      intervalFormat: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}interval_format'])!,
      intervals: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}intervals'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}timestamp'])!,
      autoAddToLedger: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}auto_add_to_ledger'])!,
      paidInstallments: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}paid_installments'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      synced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}synced'])!,
      deleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
    );
  }

  @override
  $PlansTable createAlias(String alias) {
    return $PlansTable(attachedDatabase, alias);
  }
}

class Plan extends DataClass implements Insertable<Plan> {
  final String id;
  final int userId;
  final String name;
  final String type;
  final double amount;
  final int installments;
  final bool fixPayment;
  final int intervalFormat;
  final int intervals;
  final int timestamp;
  final bool autoAddToLedger;
  final int paidInstallments;
  final String createdAt;
  final bool synced;
  final bool deleted;
  const Plan(
      {required this.id,
      required this.userId,
      required this.name,
      required this.type,
      required this.amount,
      required this.installments,
      required this.fixPayment,
      required this.intervalFormat,
      required this.intervals,
      required this.timestamp,
      required this.autoAddToLedger,
      required this.paidInstallments,
      required this.createdAt,
      required this.synced,
      required this.deleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<int>(userId);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['amount'] = Variable<double>(amount);
    map['installments'] = Variable<int>(installments);
    map['fix_payment'] = Variable<bool>(fixPayment);
    map['interval_format'] = Variable<int>(intervalFormat);
    map['intervals'] = Variable<int>(intervals);
    map['timestamp'] = Variable<int>(timestamp);
    map['auto_add_to_ledger'] = Variable<bool>(autoAddToLedger);
    map['paid_installments'] = Variable<int>(paidInstallments);
    map['created_at'] = Variable<String>(createdAt);
    map['synced'] = Variable<bool>(synced);
    map['deleted'] = Variable<bool>(deleted);
    return map;
  }

  PlansCompanion toCompanion(bool nullToAbsent) {
    return PlansCompanion(
      id: Value(id),
      userId: Value(userId),
      name: Value(name),
      type: Value(type),
      amount: Value(amount),
      installments: Value(installments),
      fixPayment: Value(fixPayment),
      intervalFormat: Value(intervalFormat),
      intervals: Value(intervals),
      timestamp: Value(timestamp),
      autoAddToLedger: Value(autoAddToLedger),
      paidInstallments: Value(paidInstallments),
      createdAt: Value(createdAt),
      synced: Value(synced),
      deleted: Value(deleted),
    );
  }

  factory Plan.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Plan(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      amount: serializer.fromJson<double>(json['amount']),
      installments: serializer.fromJson<int>(json['installments']),
      fixPayment: serializer.fromJson<bool>(json['fixPayment']),
      intervalFormat: serializer.fromJson<int>(json['intervalFormat']),
      intervals: serializer.fromJson<int>(json['intervals']),
      timestamp: serializer.fromJson<int>(json['timestamp']),
      autoAddToLedger: serializer.fromJson<bool>(json['autoAddToLedger']),
      paidInstallments: serializer.fromJson<int>(json['paidInstallments']),
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
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'amount': serializer.toJson<double>(amount),
      'installments': serializer.toJson<int>(installments),
      'fixPayment': serializer.toJson<bool>(fixPayment),
      'intervalFormat': serializer.toJson<int>(intervalFormat),
      'intervals': serializer.toJson<int>(intervals),
      'timestamp': serializer.toJson<int>(timestamp),
      'autoAddToLedger': serializer.toJson<bool>(autoAddToLedger),
      'paidInstallments': serializer.toJson<int>(paidInstallments),
      'createdAt': serializer.toJson<String>(createdAt),
      'synced': serializer.toJson<bool>(synced),
      'deleted': serializer.toJson<bool>(deleted),
    };
  }

  Plan copyWith(
          {String? id,
          int? userId,
          String? name,
          String? type,
          double? amount,
          int? installments,
          bool? fixPayment,
          int? intervalFormat,
          int? intervals,
          int? timestamp,
          bool? autoAddToLedger,
          int? paidInstallments,
          String? createdAt,
          bool? synced,
          bool? deleted}) =>
      Plan(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        name: name ?? this.name,
        type: type ?? this.type,
        amount: amount ?? this.amount,
        installments: installments ?? this.installments,
        fixPayment: fixPayment ?? this.fixPayment,
        intervalFormat: intervalFormat ?? this.intervalFormat,
        intervals: intervals ?? this.intervals,
        timestamp: timestamp ?? this.timestamp,
        autoAddToLedger: autoAddToLedger ?? this.autoAddToLedger,
        paidInstallments: paidInstallments ?? this.paidInstallments,
        createdAt: createdAt ?? this.createdAt,
        synced: synced ?? this.synced,
        deleted: deleted ?? this.deleted,
      );
  Plan copyWithCompanion(PlansCompanion data) {
    return Plan(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      amount: data.amount.present ? data.amount.value : this.amount,
      installments: data.installments.present
          ? data.installments.value
          : this.installments,
      fixPayment:
          data.fixPayment.present ? data.fixPayment.value : this.fixPayment,
      intervalFormat: data.intervalFormat.present
          ? data.intervalFormat.value
          : this.intervalFormat,
      intervals: data.intervals.present ? data.intervals.value : this.intervals,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      autoAddToLedger: data.autoAddToLedger.present
          ? data.autoAddToLedger.value
          : this.autoAddToLedger,
      paidInstallments: data.paidInstallments.present
          ? data.paidInstallments.value
          : this.paidInstallments,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      synced: data.synced.present ? data.synced.value : this.synced,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Plan(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('installments: $installments, ')
          ..write('fixPayment: $fixPayment, ')
          ..write('intervalFormat: $intervalFormat, ')
          ..write('intervals: $intervals, ')
          ..write('timestamp: $timestamp, ')
          ..write('autoAddToLedger: $autoAddToLedger, ')
          ..write('paidInstallments: $paidInstallments, ')
          ..write('createdAt: $createdAt, ')
          ..write('synced: $synced, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      userId,
      name,
      type,
      amount,
      installments,
      fixPayment,
      intervalFormat,
      intervals,
      timestamp,
      autoAddToLedger,
      paidInstallments,
      createdAt,
      synced,
      deleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Plan &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.name == this.name &&
          other.type == this.type &&
          other.amount == this.amount &&
          other.installments == this.installments &&
          other.fixPayment == this.fixPayment &&
          other.intervalFormat == this.intervalFormat &&
          other.intervals == this.intervals &&
          other.timestamp == this.timestamp &&
          other.autoAddToLedger == this.autoAddToLedger &&
          other.paidInstallments == this.paidInstallments &&
          other.createdAt == this.createdAt &&
          other.synced == this.synced &&
          other.deleted == this.deleted);
}

class PlansCompanion extends UpdateCompanion<Plan> {
  final Value<String> id;
  final Value<int> userId;
  final Value<String> name;
  final Value<String> type;
  final Value<double> amount;
  final Value<int> installments;
  final Value<bool> fixPayment;
  final Value<int> intervalFormat;
  final Value<int> intervals;
  final Value<int> timestamp;
  final Value<bool> autoAddToLedger;
  final Value<int> paidInstallments;
  final Value<String> createdAt;
  final Value<bool> synced;
  final Value<bool> deleted;
  final Value<int> rowid;
  const PlansCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.amount = const Value.absent(),
    this.installments = const Value.absent(),
    this.fixPayment = const Value.absent(),
    this.intervalFormat = const Value.absent(),
    this.intervals = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.autoAddToLedger = const Value.absent(),
    this.paidInstallments = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.synced = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlansCompanion.insert({
    required String id,
    required int userId,
    required String name,
    required String type,
    required double amount,
    required int installments,
    this.fixPayment = const Value.absent(),
    required int intervalFormat,
    required int intervals,
    required int timestamp,
    this.autoAddToLedger = const Value.absent(),
    required int paidInstallments,
    required String createdAt,
    this.synced = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        name = Value(name),
        type = Value(type),
        amount = Value(amount),
        installments = Value(installments),
        intervalFormat = Value(intervalFormat),
        intervals = Value(intervals),
        timestamp = Value(timestamp),
        paidInstallments = Value(paidInstallments),
        createdAt = Value(createdAt);
  static Insertable<Plan> custom({
    Expression<String>? id,
    Expression<int>? userId,
    Expression<String>? name,
    Expression<String>? type,
    Expression<double>? amount,
    Expression<int>? installments,
    Expression<bool>? fixPayment,
    Expression<int>? intervalFormat,
    Expression<int>? intervals,
    Expression<int>? timestamp,
    Expression<bool>? autoAddToLedger,
    Expression<int>? paidInstallments,
    Expression<String>? createdAt,
    Expression<bool>? synced,
    Expression<bool>? deleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (amount != null) 'amount': amount,
      if (installments != null) 'installments': installments,
      if (fixPayment != null) 'fix_payment': fixPayment,
      if (intervalFormat != null) 'interval_format': intervalFormat,
      if (intervals != null) 'intervals': intervals,
      if (timestamp != null) 'timestamp': timestamp,
      if (autoAddToLedger != null) 'auto_add_to_ledger': autoAddToLedger,
      if (paidInstallments != null) 'paid_installments': paidInstallments,
      if (createdAt != null) 'created_at': createdAt,
      if (synced != null) 'synced': synced,
      if (deleted != null) 'deleted': deleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlansCompanion copyWith(
      {Value<String>? id,
      Value<int>? userId,
      Value<String>? name,
      Value<String>? type,
      Value<double>? amount,
      Value<int>? installments,
      Value<bool>? fixPayment,
      Value<int>? intervalFormat,
      Value<int>? intervals,
      Value<int>? timestamp,
      Value<bool>? autoAddToLedger,
      Value<int>? paidInstallments,
      Value<String>? createdAt,
      Value<bool>? synced,
      Value<bool>? deleted,
      Value<int>? rowid}) {
    return PlansCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      installments: installments ?? this.installments,
      fixPayment: fixPayment ?? this.fixPayment,
      intervalFormat: intervalFormat ?? this.intervalFormat,
      intervals: intervals ?? this.intervals,
      timestamp: timestamp ?? this.timestamp,
      autoAddToLedger: autoAddToLedger ?? this.autoAddToLedger,
      paidInstallments: paidInstallments ?? this.paidInstallments,
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
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (installments.present) {
      map['installments'] = Variable<int>(installments.value);
    }
    if (fixPayment.present) {
      map['fix_payment'] = Variable<bool>(fixPayment.value);
    }
    if (intervalFormat.present) {
      map['interval_format'] = Variable<int>(intervalFormat.value);
    }
    if (intervals.present) {
      map['intervals'] = Variable<int>(intervals.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<int>(timestamp.value);
    }
    if (autoAddToLedger.present) {
      map['auto_add_to_ledger'] = Variable<bool>(autoAddToLedger.value);
    }
    if (paidInstallments.present) {
      map['paid_installments'] = Variable<int>(paidInstallments.value);
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
    return (StringBuffer('PlansCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('installments: $installments, ')
          ..write('fixPayment: $fixPayment, ')
          ..write('intervalFormat: $intervalFormat, ')
          ..write('intervals: $intervals, ')
          ..write('timestamp: $timestamp, ')
          ..write('autoAddToLedger: $autoAddToLedger, ')
          ..write('paidInstallments: $paidInstallments, ')
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
  late final $PlansTable plans = $PlansTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [transactions, plans];
}

typedef $$TransactionsTableCreateCompanionBuilder = TransactionsCompanion
    Function({
  required String id,
  required int userId,
  required String type,
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
  Value<String> type,
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

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

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

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

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

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

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
            Value<String> type = const Value.absent(),
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
            type: type,
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
            required String type,
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
            type: type,
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
typedef $$PlansTableCreateCompanionBuilder = PlansCompanion Function({
  required String id,
  required int userId,
  required String name,
  required String type,
  required double amount,
  required int installments,
  Value<bool> fixPayment,
  required int intervalFormat,
  required int intervals,
  required int timestamp,
  Value<bool> autoAddToLedger,
  required int paidInstallments,
  required String createdAt,
  Value<bool> synced,
  Value<bool> deleted,
  Value<int> rowid,
});
typedef $$PlansTableUpdateCompanionBuilder = PlansCompanion Function({
  Value<String> id,
  Value<int> userId,
  Value<String> name,
  Value<String> type,
  Value<double> amount,
  Value<int> installments,
  Value<bool> fixPayment,
  Value<int> intervalFormat,
  Value<int> intervals,
  Value<int> timestamp,
  Value<bool> autoAddToLedger,
  Value<int> paidInstallments,
  Value<String> createdAt,
  Value<bool> synced,
  Value<bool> deleted,
  Value<int> rowid,
});

class $$PlansTableFilterComposer extends Composer<_$AppDatabase, $PlansTable> {
  $$PlansTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get installments => $composableBuilder(
      column: $table.installments, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get fixPayment => $composableBuilder(
      column: $table.fixPayment, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get intervalFormat => $composableBuilder(
      column: $table.intervalFormat,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get intervals => $composableBuilder(
      column: $table.intervals, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get autoAddToLedger => $composableBuilder(
      column: $table.autoAddToLedger,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get paidInstallments => $composableBuilder(
      column: $table.paidInstallments,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnFilters(column));
}

class $$PlansTableOrderingComposer
    extends Composer<_$AppDatabase, $PlansTable> {
  $$PlansTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get installments => $composableBuilder(
      column: $table.installments,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get fixPayment => $composableBuilder(
      column: $table.fixPayment, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get intervalFormat => $composableBuilder(
      column: $table.intervalFormat,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get intervals => $composableBuilder(
      column: $table.intervals, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get autoAddToLedger => $composableBuilder(
      column: $table.autoAddToLedger,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get paidInstallments => $composableBuilder(
      column: $table.paidInstallments,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnOrderings(column));
}

class $$PlansTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlansTable> {
  $$PlansTableAnnotationComposer({
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

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<int> get installments => $composableBuilder(
      column: $table.installments, builder: (column) => column);

  GeneratedColumn<bool> get fixPayment => $composableBuilder(
      column: $table.fixPayment, builder: (column) => column);

  GeneratedColumn<int> get intervalFormat => $composableBuilder(
      column: $table.intervalFormat, builder: (column) => column);

  GeneratedColumn<int> get intervals =>
      $composableBuilder(column: $table.intervals, builder: (column) => column);

  GeneratedColumn<int> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<bool> get autoAddToLedger => $composableBuilder(
      column: $table.autoAddToLedger, builder: (column) => column);

  GeneratedColumn<int> get paidInstallments => $composableBuilder(
      column: $table.paidInstallments, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);
}

class $$PlansTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PlansTable,
    Plan,
    $$PlansTableFilterComposer,
    $$PlansTableOrderingComposer,
    $$PlansTableAnnotationComposer,
    $$PlansTableCreateCompanionBuilder,
    $$PlansTableUpdateCompanionBuilder,
    (Plan, BaseReferences<_$AppDatabase, $PlansTable, Plan>),
    Plan,
    PrefetchHooks Function()> {
  $$PlansTableTableManager(_$AppDatabase db, $PlansTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<int> installments = const Value.absent(),
            Value<bool> fixPayment = const Value.absent(),
            Value<int> intervalFormat = const Value.absent(),
            Value<int> intervals = const Value.absent(),
            Value<int> timestamp = const Value.absent(),
            Value<bool> autoAddToLedger = const Value.absent(),
            Value<int> paidInstallments = const Value.absent(),
            Value<String> createdAt = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PlansCompanion(
            id: id,
            userId: userId,
            name: name,
            type: type,
            amount: amount,
            installments: installments,
            fixPayment: fixPayment,
            intervalFormat: intervalFormat,
            intervals: intervals,
            timestamp: timestamp,
            autoAddToLedger: autoAddToLedger,
            paidInstallments: paidInstallments,
            createdAt: createdAt,
            synced: synced,
            deleted: deleted,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required int userId,
            required String name,
            required String type,
            required double amount,
            required int installments,
            Value<bool> fixPayment = const Value.absent(),
            required int intervalFormat,
            required int intervals,
            required int timestamp,
            Value<bool> autoAddToLedger = const Value.absent(),
            required int paidInstallments,
            required String createdAt,
            Value<bool> synced = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PlansCompanion.insert(
            id: id,
            userId: userId,
            name: name,
            type: type,
            amount: amount,
            installments: installments,
            fixPayment: fixPayment,
            intervalFormat: intervalFormat,
            intervals: intervals,
            timestamp: timestamp,
            autoAddToLedger: autoAddToLedger,
            paidInstallments: paidInstallments,
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

typedef $$PlansTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PlansTable,
    Plan,
    $$PlansTableFilterComposer,
    $$PlansTableOrderingComposer,
    $$PlansTableAnnotationComposer,
    $$PlansTableCreateCompanionBuilder,
    $$PlansTableUpdateCompanionBuilder,
    (Plan, BaseReferences<_$AppDatabase, $PlansTable, Plan>),
    Plan,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$PlansTableTableManager get plans =>
      $$PlansTableTableManager(_db, _db.plans);
}
