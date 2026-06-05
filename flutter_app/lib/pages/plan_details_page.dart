import 'package:flutter/material.dart';
import 'package:my_bookkeeping/utils/app_state.dart';
import 'package:my_bookkeeping/utils/datetime.dart';
import 'package:my_bookkeeping/widgets/time_picker_sheet.dart';
import 'package:provider/provider.dart';
import 'package:my_bookkeeping/service/plan_service.dart';

class PlanBottomSheet {
  static void open(BuildContext context, {PlanEntry? plan}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.9,
        child: PlanDetailsPage(
          plan: plan,
        ),
      ),
    );
  }
}

class PlanDetailsPage extends StatefulWidget {
  final PlanEntry? plan;

  const PlanDetailsPage({super.key, this.plan});

  @override
  State<PlanDetailsPage> createState() => _PlanDetailsPageState();
}

class _PlanDetailsPageState extends State<PlanDetailsPage> {
  @override
  Widget build(BuildContext context) {
    String name = widget.plan?.name ?? '';
    String amount = widget.plan?.totalAmount.toString() ?? '';
    String installments = widget.plan?.totalInstallments.toString() ?? '6';
    bool fixPayment = widget.plan?.fixPayment ?? false;
    int intervalFormat = widget.plan?.intervalFormat ?? 0;
    String intervals = widget.plan?.intervals.toString() ?? '30';
    int timestamp =
        widget.plan?.timestamp ?? DateTime.now().millisecondsSinceEpoch;
    PlanDirection direction = widget.plan?.direction ?? PlanDirection.expense;
    bool autoAddToLedger = widget.plan?.autoAddToLedger ?? false;

    final appState = Provider.of<AppState>(context, listen: false);
    final dialogTitle =
        widget.plan == null ? 'Add New Plan Card' : 'Edit Plan Card';
    DateTime startDate = DateTime.fromMillisecondsSinceEpoch(timestamp);

    final nameController = TextEditingController(text: name);
    final amountController = TextEditingController(text: amount);
    final installmentsController = TextEditingController(text: installments);
    final intervalsController = TextEditingController(text: intervals);

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
                          color: Color.fromARGB(255, 255, 79, 79), width: 2.0),
                    ),
                  ),
                  onChanged: (value) => name = value,
                ),
                const SizedBox(height: 16),
                const Text('Type'),
                const SizedBox(height: 8),
                SizedBox(
                  width: double
                      .infinity, // Forces the container to take full width
                  child: SegmentedButton<PlanDirection>(
                    style: SegmentedButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                          color: Color.fromARGB(255, 255, 79, 79), width: 2.0),
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
                          color: Color.fromARGB(255, 255, 79, 79), width: 2.0),
                    ),
                  ),
                  onChanged: (value) => installments = value,
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  title: const Text('Fix payment period'),
                  checkboxShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  activeColor: const Color(0xFFFF5A5A),
                  value: fixPayment,
                  onChanged: (value) {
                    setModalState(() {
                      fixPayment = value ?? true;
                      if (value == false) autoAddToLedger = false;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                ),
                if (fixPayment) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double
                        .infinity, // Forces the container to take full width
                    child: SegmentedButton<int>(
                      style: SegmentedButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        backgroundColor: const Color(0xFFFFF4F4),
                        selectedForegroundColor: Colors.white,
                        selectedBackgroundColor: const Color(0xFFFF5A5A),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                      ),
                      segments: const [
                        ButtonSegment<int>(
                          value: 0,
                          label: Text('Days'),
                        ),
                        ButtonSegment<int>(
                          value: 1,
                          label: Text('Weeks'),
                        ),
                        ButtonSegment<int>(
                          value: 2,
                          label: Text('Months'),
                        ),
                      ],
                      selected: <int>{intervalFormat},
                      onSelectionChanged: (selection) {
                        setModalState(() {
                          intervalFormat = selection.first;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Payment Interval (days)'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: intervalsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'e.g.: 30',
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
                    onChanged: (value) => intervals = value,
                  ),
                  const SizedBox(height: 16),
                  const Text('Installment Start Date'),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => TimePickerBottomSheet.open(
                        context, startDate, true, true, true,
                        onConfirm: (date) {
                      setModalState(() {
                        startDate = date;
                      });
                    }),
                    child: Container(
                        width: double.infinity,
                        height: double.tryParse('50'),
                        alignment: AlignmentGeometry.centerLeft,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          color: const Color.fromARGB(255, 255, 199, 199),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Text(
                          '${formatDateNum(startDate)}',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                        )),
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
                ],
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
                          parsedInstallments <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Please fill in the complete and valid name, amount, number of terms, and payment interval'),
                          ),
                        );
                        return;
                      }

                      if (widget.plan == null) {
                        appState.addPlan(
                          name,
                          direction,
                          parsedAmount,
                          parsedInstallments,
                          fixPayment,
                          intervalFormat,
                          parsedIntervals!,
                          startDate.millisecondsSinceEpoch,
                          autoAddToLedger,
                        );
                      } else {
                        appState.updatePlan(
                          widget.plan!.id,
                          name: name,
                          direction: direction as PlanDirection?,
                          totalAmount: parsedAmount,
                          totalInstallments: parsedInstallments,
                          fixPayment: fixPayment,
                          intervalFormat: intervalFormat,
                          intervals: parsedIntervals,
                          timestamp: startDate.millisecondsSinceEpoch,
                          autoAddToLedger: autoAddToLedger,
                        );
                      }

                      Navigator.pop(context);
                      _closePlanMenu();
                    },
                    child: Text(
                        widget.plan == null ? 'save plan' : 'update plan',
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
