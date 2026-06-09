import 'package:flutter/material.dart';
import 'package:my_bookkeeping/service/api_service.dart';
import 'package:my_bookkeeping/utils/app_state.dart';
import 'package:my_bookkeeping/utils/datetime.dart';
import 'package:provider/provider.dart';
import 'package:my_bookkeeping/pages/plan_details_page.dart';
import 'package:my_bookkeeping/service/plan_service.dart';

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

  Future<void> _deletePlan(String planId) async {
    await APIService().removePlan(planId);
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
            onPressed: () => PlanBottomSheet.open(context,
                onConfirm: () => _closePlanMenu()),
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
                    final totalPaymentDate =
                        plan.intervals * plan.paidInstallments;

                    DateTime nextPaymentDate = calculateNextDate(
                        DateTime.fromMillisecondsSinceEpoch(plan.timestamp),
                        plan.intervalFormat,
                        totalPaymentDate);

                    final nextPaymentDateText = formatDateNum(nextPaymentDate);

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
                                    autoAddLabel(plan.autoAddToLedger == 1),
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
                                              PlanBottomSheet.open(context,
                                                  plan: plan as PlanEntry?,
                                                  onConfirm: () =>
                                                      _closePlanMenu());
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
                                    title: plan.fixPayment == 1
                                        ? 'next payment date'
                                        : 'remaining terms',
                                    value: plan.remainingBalance != 0
                                        ? plan.fixPayment == 1
                                            ? nextPaymentDateText
                                            : remainText
                                        : 'Completed',
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
                                    plan.autoAddToLedger == 1
                                        ? 'auto add is on'
                                        : 'auto add is off',
                                    style: const TextStyle(
                                        fontSize: 13, color: Colors.black87),
                                  ),
                                ),
                                plan.remainingInstallments > 0
                                    ? plan.autoAddToLedger == 0
                                        ? ElevatedButton.icon(
                                            onPressed: () {
                                              if (plan.paidInstallments <
                                                  plan.totalInstallments) {
                                                APIService().markPlanPaid(plan);
                                              }
                                            },
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
                onPressed: () => PlanBottomSheet.open(context,
                    onConfirm: () => _closePlanMenu()),
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
