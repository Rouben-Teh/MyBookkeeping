import 'package:flutter/material.dart';

enum PlanDirection { expense, income }

class PlanEntry {
  PlanEntry({
    required this.name,
    required this.direction,
    required this.totalAmount,
    required this.totalInstallments,
    required this.autoAddToLedger,
    this.paidInstallments = 0,
  });

  final String name;
  final PlanDirection direction;
  final double totalAmount;
  final int totalInstallments;
  final bool autoAddToLedger;
  int paidInstallments;

  int get remainingInstallments =>
      (totalInstallments - paidInstallments).clamp(0, totalInstallments);

  double get remainingBalance =>
      ((totalAmount / totalInstallments) * remainingInstallments)
          .clamp(0, totalAmount);

  double get progress =>
      totalInstallments == 0 ? 0 : paidInstallments / totalInstallments;
}

class PlansPage extends StatefulWidget {
  const PlansPage({super.key});

  @override
  State<PlansPage> createState() => _PlansPageState();
}

class _PlansPageState extends State<PlansPage> {
  final List<PlanEntry> _plans = [
    PlanEntry(
      name: 'iPhone 14 分期付款',
      direction: PlanDirection.expense,
      totalAmount: 6999,
      totalInstallments: 12,
      paidInstallments: 3,
      autoAddToLedger: true,
    ),
    PlanEntry(
      name: '借给小王',
      direction: PlanDirection.income,
      totalAmount: 3000,
      totalInstallments: 6,
      paidInstallments: 1,
      autoAddToLedger: false,
    ),
  ];

  void _showAddPlanSheet() {
    String name = '';
    String amount = '';
    String installments = '6';
    PlanDirection direction = PlanDirection.expense;
    bool autoAddToLedger = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '新增计划卡片',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text('名称'),
                    const SizedBox(height: 8),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: '例如：学习课程分期、借给朋友',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) => name = value,
                    ),
                    const SizedBox(height: 16),
                    const Text('类型'),
                    const SizedBox(height: 8),
                    SegmentedButton<PlanDirection>(
                      segments: const [
                        ButtonSegment<PlanDirection>(
                          value: PlanDirection.expense,
                          label: Text('支出'),
                        ),
                        ButtonSegment<PlanDirection>(
                          value: PlanDirection.income,
                          label: Text('收入'),
                        ),
                      ],
                      selected: <PlanDirection>{direction},
                      onSelectionChanged: (selection) {
                        setModalState(() {
                          direction = selection.first;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text('金额'),
                    const SizedBox(height: 8),
                    TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: '例如：1200',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) => amount = value,
                    ),
                    const SizedBox(height: 16),
                    const Text('分几期'),
                    const SizedBox(height: 8),
                    TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: '例如：6',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) => installments = value,
                    ),
                    const SizedBox(height: 16),
                    CheckboxListTile(
                      title: const Text('是否自动添加到记账页面'),
                      value: autoAddToLedger,
                      onChanged: (value) {
                        setModalState(() {
                          autoAddToLedger = value ?? true;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF5A5A),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          final parsedAmount = double.tryParse(amount);
                          final parsedInstallments = int.tryParse(installments);
                          if (name.trim().isEmpty ||
                              parsedAmount == null ||
                              parsedInstallments == null ||
                              parsedInstallments <= 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('请填写完整、有效的名称、金额和期数'),
                              ),
                            );
                            return;
                          }

                          setState(() {
                            _plans.insert(
                              0,
                              PlanEntry(
                                name: name.trim(),
                                direction: direction,
                                totalAmount: parsedAmount,
                                totalInstallments: parsedInstallments,
                                autoAddToLedger: autoAddToLedger,
                              ),
                            );
                          });
                          Navigator.pop(context);
                        },
                        child: const Text('保存计划'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _markPaid(PlanEntry plan) {
    setState(() {
      if (plan.paidInstallments < plan.totalInstallments) {
        plan.paidInstallments += 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool hasPlans = _plans.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Plans',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFFF5A5A),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            tooltip: 'Add new plan',
            onPressed: _showAddPlanSheet,
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFFFFF4F4),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: hasPlans
              ? ListView.builder(
                  itemCount: _plans.length,
                  itemBuilder: (context, index) {
                    final plan = _plans[index];
                    final isExpense = plan.direction == PlanDirection.expense;
                    final accentColor =
                        isExpense ? Colors.redAccent : Colors.green;
                    final remainText = '${plan.remainingInstallments} 期剩余';

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        plan.name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        isExpense ? '支出类计划' : '收入类计划',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  // margin: const EdgeInsets.only(top: 10.0),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: accentColor.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    autoAddLabel(plan.autoAddToLedger),
                                    style: TextStyle(
                                      color: accentColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      print('clicked');
                                    },
                                    // color: Colors.amber,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 6),
                                      child: Icon(
                                        Icons.edit,
                                        color: Color.fromARGB(255, 61, 61, 61),
                                        size: 20,
                                      ),
                                    )),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _infoBox(
                                    title: '剩余期数',
                                    value: remainText,
                                    icon: Icons.schedule,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _infoBox(
                                    title: '余额',
                                    value:
                                        '¥${plan.remainingBalance.toStringAsFixed(2)}',
                                    icon: Icons.account_balance_wallet,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(999),
                              child: LinearProgressIndicator(
                                value: plan.progress,
                                minHeight: 8,
                                backgroundColor: Colors.black12,
                                color: accentColor,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '已完成 ${plan.paidInstallments}/${plan.totalInstallments} 期',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black54),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    plan.autoAddToLedger
                                        ? '已开启自动添加到记账页面'
                                        : '未开启自动添加到记账页面',
                                    style: const TextStyle(
                                        fontSize: 13, color: Colors.black87),
                                  ),
                                ),
                                !plan.autoAddToLedger
                                    ? ElevatedButton.icon(
                                        onPressed: () => _markPaid(plan),
                                        icon: const Icon(Icons.check, size: 18),
                                        label: const Text('记一笔'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: accentColor,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : _buildEmptyState(),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.event_note, size: 48, color: Color(0xFFFF5A5A)),
              const SizedBox(height: 16),
              const Text(
                '计划页用于管理分期付款、借出/借入、以及需要按期还款的事务。',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 12),
              const Text(
                '你可以在右上角添加新的卡片，设置名称、收入/支出、分几期，以及是否自动同步到记账页面。',
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontSize: 14, color: Colors.black54, height: 1.5),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _showAddPlanSheet,
                icon: const Icon(Icons.add),
                label: const Text('创建第一个计划'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5A5A),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoBox({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4F4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: const Color(0xFFFF5A5A)),
          const SizedBox(height: 8),
          Text(title,
              style: const TextStyle(fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 6),
          Text(value,
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  String autoAddLabel(bool autoAddToLedger) {
    return autoAddToLedger ? 'Auto' : 'Manual';
  }
}
