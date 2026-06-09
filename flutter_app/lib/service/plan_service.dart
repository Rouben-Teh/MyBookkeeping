enum PlanDirection { expense, income }

class PlanEntry {
  PlanEntry({
    required this.id,
    required this.user_id,
    required this.name,
    required this.direction,
    required this.totalAmount,
    required this.totalInstallments,
    required this.fixPayment,
    required this.intervalFormat,
    required this.intervals,
    required this.timestamp,
    required this.autoAddToLedger,
    this.created_at = '',
    this.synced = 0,
    this.deleted = 0,
    this.paidInstallments = 0,
  });

  final String id;
  int user_id;
  String name;
  PlanDirection direction;
  double totalAmount;
  int totalInstallments;
  int fixPayment;
  int intervalFormat;
  int intervals;
  int timestamp;
  int autoAddToLedger;
  int paidInstallments;

  String created_at;
  int synced;
  int deleted;

  int get remainingInstallments =>
      (totalInstallments - paidInstallments).clamp(0, totalInstallments);

  double get remainingBalance =>
      ((totalAmount / totalInstallments) * remainingInstallments)
          .clamp(0, totalAmount);

  double get progress =>
      totalInstallments == 0 ? 0 : paidInstallments / totalInstallments;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': user_id,
      'name': name,
      'direction': direction.toString(),
      'totalAmount': totalAmount,
      'totalInstallments': totalInstallments,
      'fixPayment': fixPayment,
      'intervalFormat': intervalFormat,
      'intervals': intervals,
      'timestamp': timestamp,
      'autoAddToLedger': autoAddToLedger,
      'paidInstallments': paidInstallments,
      'created_at': created_at,
      'synced': synced,
      'deleted': deleted
    };
  }

  factory PlanEntry.fromJson(Map<String, dynamic> json) {
    return PlanEntry(
        id: json['id'],
        user_id: json['userId'],
        name: json['name'],
        direction: json['direction'] == 'PlanDirection.expense'
            ? PlanDirection.expense
            : PlanDirection.income,
        totalAmount: json['totalAmount'],
        totalInstallments: json['totalInstallments'],
        fixPayment: json['fixPayment'] == false ? 0 : 1,
        intervalFormat: json['intervalFormat'],
        intervals: json['intervals'],
        timestamp: json['timestamp'],
        autoAddToLedger: json['autoAddToLedger'] == false ? 0 : 1,
        paidInstallments: json['paidInstallments'],
        created_at: json['createdAt'],
        synced: json['synced'] == false ? 0 : 1,
        deleted: json['deleted'] == false ? 0 : 1);
  }
}
