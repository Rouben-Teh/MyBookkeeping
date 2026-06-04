import 'package:flutter/material.dart';
import 'package:my_bookkeeping/singleton/singleton.dart';
import 'package:my_bookkeeping/utils/app_state.dart';
import 'package:provider/provider.dart';

enum PlanDirection { expense, income }

class PlanEntry {
  PlanEntry({
    required this.name,
    required this.direction,
    required this.totalAmount,
    required this.totalInstallments,
    required this.intervals,
    required this.autoAddToLedger,
    this.paidInstallments = 0,
  });

  final String id =
      '${Global.appState.userId}${DateTime.now().millisecondsSinceEpoch}';
  int userId = int.parse(Global.appState.userId);
  String name;
  PlanDirection direction;
  double totalAmount;
  int totalInstallments;
  int intervals; // default 30 days
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

class PlansPage extends StatefulWidget {
  const PlansPage({super.key});

  @override
  State<PlansPage> createState() => _PlansPageState();
}

class _PlansPageState extends State<PlansPage> {
  String? _expandedPlanId;

  void _togglePlanMenu(String planId) {
    setState(() {
      _expandedPlanId = _expandedPlanId == planId ? null : planId;
    });
  }

  void _closePlanMenu() {
    setState(() {
      _expandedPlanId = null;
    });
  }

  void _showAddPlanSheet({PlanEntry? plan}) {
    String name = plan?.name ?? '';
    String amount = plan?.totalAmount.toString() ?? '';
    String installments = plan?.totalInstallments.toString() ?? '6';
    String intervals = plan?.intervals.toString() ?? '30';
    PlanDirection direction = plan?.direction ?? PlanDirection.expense;
    bool autoAddToLedger = plan?.autoAddToLedger ?? true;

    final nameController = TextEditingController(text: name);
    final amountController = TextEditingController(text: amount);
    final installmentsController = TextEditingController(text: installments);
    final intervalsController = TextEditingController(text: intervals);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final appState = Provider.of<AppState>(context, listen: false);
        final dialogTitle =
            plan == null ? 'Add New Plan Card' : 'Edit Plan Card';

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
                        Text(
                          dialogTitle,
                          style: const TextStyle(
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
                    const Text('Name'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        hintText:
                            'e.g.: Learning course installment, lending to friends',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 255, 79, 79),
                              width: 2.0),
                        ),
                      ),
                      onChanged: (value) => name = value,
                    ),
                    const SizedBox(height: 16),
                    const Text('Type'),
                    const SizedBox(height: 8),
                    SegmentedButton<PlanDirection>(
                      style: SegmentedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFF4F4),
                        selectedForegroundColor: Colors.white,
                        selectedBackgroundColor: const Color(0xFFFF5A5A),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                      ),
                      segments: const [
                        ButtonSegment<PlanDirection>(
                          value: PlanDirection.expense,
                          label: Text('Expense'),
                        ),
                        ButtonSegment<PlanDirection>(
                          value: PlanDirection.income,
                          label: Text('Income'),
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
                    const Text('Amount'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'e.g.: 1200',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 255, 79, 79),
                              width: 2.0),
                        ),
                      ),
                      onChanged: (value) => amount = value,
                    ),
                    const SizedBox(height: 16),
                    const Text('Number of Terms'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: installmentsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'e.g.: 6',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 255, 79, 79),
                              width: 2.0),
                        ),
                      ),
                      onChanged: (value) => installments = value,
                    ),
                    const SizedBox(height: 16),
                    const Text('Payment Interval (days)'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: intervalsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'e.g.: 6',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 255, 79, 79),
                              width: 2.0),
                        ),
                      ),
                      onChanged: (value) => installments = value,
                    ),
                    const SizedBox(height: 16),
                    CheckboxListTile(
                      title: const Text('auto add to ledger'),
                      checkboxShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      activeColor: const Color(0xFFFF5A5A),
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
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        onPressed: () {
                          final parsedAmount = double.tryParse(amount);
                          final parsedInstallments = int.tryParse(installments);
                          final parsedIntervals = int.tryParse(intervals);
                          if (name.trim().isEmpty ||
                              parsedAmount == null ||
                              parsedInstallments == null ||
                              parsedInstallments <= 0 ||
                              parsedIntervals == null ||
                              parsedIntervals <= 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Please fill in the complete and valid name, amount, number of terms, and payment interval'),
                              ),
                            );
                            return;
                          }

                          if (plan == null) {
                            appState.addPlan(
                              name,
                              direction,
                              parsedAmount,
                              parsedInstallments,
                              parsedIntervals,
                              autoAddToLedger,
                            );
                          } else {
                            appState.updatePlan(
                              plan.id,
                              name: name,
                              direction: direction as PlanDirection?,
                              totalAmount: parsedAmount,
                              totalInstallments: parsedInstallments,
                              intervals: parsedIntervals,
                              autoAddToLedger: autoAddToLedger,
                            );
                          }

                          Navigator.pop(context);
                          _closePlanMenu();
                        },
                        child: Text(plan == null ? 'save plan' : 'update plan'),
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

  void _deletePlan(String planId) {
    final appState = Provider.of<AppState>(context, listen: false);
    appState.removePlan(planId);
    _closePlanMenu();
  }

  Widget _buildPlanAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: true);
    final bool hasPlans = appState.plans.isNotEmpty;

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
                  itemCount: appState.plans.length,
                  itemBuilder: (context, index) {
                    final plan = appState.plans[index];
                    final isExpense = plan.direction == PlanDirection.expense;
                    final accentColor =
                        isExpense ? Colors.redAccent : Colors.green;
                    final remainText =
                        '${plan.remainingInstallments} remaining terms';
                    final isExpanded = _expandedPlanId == plan.id;

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
                                        isExpense
                                            ? 'expense plan'
                                            : 'income plan',
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
                                SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () => _togglePlanMenu(plan.id),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color:
                                          const Color.fromARGB(255, 99, 99, 99)
                                              .withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 8),
                                    child: Icon(
                                      Icons.settings,
                                      color: Color.fromARGB(255, 61, 61, 61),
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            AnimatedSize(
                              duration: const Duration(milliseconds: 220),
                              curve: Curves.easeInOut,
                              child: isExpanded
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          top: 12, bottom: 8),
                                      child: Row(
                                        children: [
                                          _buildPlanAction(
                                            icon: Icons.edit,
                                            label: 'Edit',
                                            color: Colors.blue.shade700,
                                            onTap: () {
                                              _showAddPlanSheet(
                                                  plan: plan as PlanEntry?);
                                            },
                                          ),
                                          const SizedBox(width: 8),
                                          _buildPlanAction(
                                            icon: Icons.delete,
                                            label: 'Delete',
                                            color: Colors.red.shade700,
                                            onTap: () => _deletePlan(plan.id),
                                          ),
                                          const SizedBox(width: 8),
                                          _buildPlanAction(
                                            icon: Icons.close,
                                            label: 'Close',
                                            color: Colors.grey.shade800,
                                            onTap: _closePlanMenu,
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _infoBox(
                                    title: 'remaining terms',
                                    value: remainText,
                                    icon: Icons.schedule,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _infoBox(
                                    title: 'balance',
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
                              'already paid: ${plan.paidInstallments}/${plan.totalInstallments} installments',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black54),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    plan.autoAddToLedger
                                        ? 'auto add is on'
                                        : 'auto add is off',
                                    style: const TextStyle(
                                        fontSize: 13, color: Colors.black87),
                                  ),
                                ),
                                plan.remainingInstallments > 0
                                    ? !plan.autoAddToLedger
                                        ? ElevatedButton.icon(
                                            onPressed: () =>
                                                appState.markPlanPaid(plan.id),
                                            icon: const Icon(Icons.check,
                                                size: 18),
                                            label: const Text('Add to ledger'),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: accentColor,
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                              ),
                                            ),
                                          )
                                        : SizedBox()
                                    : Text(
                                        'plan completed',
                                        style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.black87),
                                      ),
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
                'The schedule page is used to manage installment payments, lending/borrowing, and transactions that require timely repayment.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 12),
              const Text(
                'You can add new cards in the top right corner, set the name, income/expense, number of terms, and whether to automatically sync to the accounting page.',
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontSize: 14, color: Colors.black54, height: 1.5),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _showAddPlanSheet,
                icon: const Icon(Icons.add),
                label: const Text('create my first plan'),
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
