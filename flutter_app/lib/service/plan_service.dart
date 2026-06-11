class PlanEntry {
  PlanEntry({
    required this.id,
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
    this.createdAt = '',
    this.synced = 0,
    this.deleted = 0,
    this.paidInstallments = 0,
  });

  final String id;
  int userId;
  String name;
  String type;
  double amount;
  int installments;
  int fixPayment;
  int intervalFormat;
  int intervals;
  int timestamp;
  int autoAddToLedger;
  int paidInstallments;

  String createdAt;
  int synced;
  int deleted;

  int get remainingInstallments =>
      (installments - paidInstallments).clamp(0, installments);

  double get remainingBalance =>
      ((amount / installments) * remainingInstallments).clamp(0, amount);

  double get progress =>
      installments == 0 ? 0 : paidInstallments / installments;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'type': type.toString(),
      'amount': amount,
      'installments': installments,
      'fix_payment': fixPayment,
      'interval_format': intervalFormat,
      'intervals': intervals,
      'timestamp': timestamp,
      'auto_add_to_ledger': autoAddToLedger,
      'paid_installments': paidInstallments,
      'created_at': createdAt,
      'synced': synced,
      'deleted': deleted
    };
  }

  factory PlanEntry.fromJson(Map<String, dynamic> json) {
    return PlanEntry(
        id: json['id'],
        userId: json['userId'],
        name: json['name'],
        type: json['type'] == 'expense' ? 'expense' : 'income',
        amount: json['amount'],
        installments: json['installments'],
        fixPayment: json['fixPayment'] == false ? 0 : 1,
        intervalFormat: json['intervalFormat'],
        intervals: json['intervals'],
        timestamp: json['timestamp'],
        autoAddToLedger: json['autoAddToLedger'] == false ? 0 : 1,
        paidInstallments: json['paidInstallments'],
        createdAt: json['createdAt'],
        synced: json['synced'] == false ? 0 : 1,
        deleted: json['deleted'] == false ? 0 : 1);
  }
}
