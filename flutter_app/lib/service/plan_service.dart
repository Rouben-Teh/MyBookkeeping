enum PlanDirection { expense, income }

class PlanEntry {
  PlanEntry({
    required this.id,
    required this.userId,
    required this.name,
    required this.direction,
    required this.totalAmount,
    required this.totalInstallments,
    required this.fixPayment,
    required this.intervalFormat,
    required this.intervals,
    required this.timestamp,
    required this.autoAddToLedger,
    this.paidInstallments = 0,
  });

  final String id;
  int userId;
  String name;
  PlanDirection direction;
  double totalAmount;
  int totalInstallments;
  bool fixPayment;
  int intervalFormat;
  int intervals;
  int timestamp;
  bool autoAddToLedger;
  int paidInstallments;

  int get remainingInstallments =>
      (totalInstallments - paidInstallments).clamp(0, totalInstallments);

  double get remainingBalance =>
      ((totalAmount / totalInstallments) * remainingInstallments)
          .clamp(0, totalAmount);

  double get progress =>
      totalInstallments == 0 ? 0 : paidInstallments / totalInstallments;
}
