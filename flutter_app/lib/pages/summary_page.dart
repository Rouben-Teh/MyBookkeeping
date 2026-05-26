import 'package:flutter/material.dart';
import 'package:my_bookkeeping/widgets/line_chart.dart';
import 'package:my_bookkeeping/widgets/pie_chart.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({super.key});

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  late DateTime fromMonth;
  late DateTime toMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    fromMonth = DateTime(now.year, now.month - 2);
    toMonth = now;
  }

  int get monthsSpan {
    return (toMonth.year - fromMonth.year) * 12 +
        (toMonth.month - fromMonth.month) +
        1;
  }

  int get placeholderTransactionCount {
    return 18 + monthsSpan * 7;
  }

  double get placeholderExpense {
    return 1200 + monthsSpan * 240.0;
  }

  double get placeholderIncome {
    return 1800 + monthsSpan * 300.0;
  }

  double get placeholderBalance {
    return placeholderIncome - placeholderExpense;
  }

  bool get isValidRange => !fromMonth.isAfter(toMonth);

  Widget _summaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _monthSelector() {
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '选择月份范围',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _monthDropDown(
                  label: '从',
                  value: fromMonth,
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      fromMonth = value;
                    });
                  },
                ),
                _monthDropDown(
                  label: '到',
                  value: toMonth,
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      toMonth = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (!isValidRange)
              const Text(
                '开始月份不能晚于结束月份。',
                style: TextStyle(color: Colors.redAccent),
              ),
          ],
        ),
      ),
    );
  }

  Widget _monthDropDown({
    required String label,
    required DateTime value,
    required ValueChanged<DateTime?> onChanged,
  }) {
    final now = DateTime.now();
    final years = List.generate(5, (index) => now.year - 2 + index);

    return SizedBox(
      width: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 6),
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: value.year,
                  isExpanded: true,
                  items: years
                      .map(
                        (year) => DropdownMenuItem(
                          value: year,
                          child: Text('$year'),
                        ),
                      )
                      .toList(),
                  onChanged: (year) {
                    if (year == null) return;
                    final updated = DateTime(year, value.month);
                    onChanged(updated);
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: value.month,
                  isExpanded: true,
                  items: List.generate(12, (index) {
                    final month = index + 1;
                    return DropdownMenuItem(
                      value: month,
                      child: Text('${month.toString().padLeft(2, '0')}'),
                    );
                  }),
                  onChanged: (month) {
                    if (month == null) return;
                    final updated = DateTime(value.year, month);
                    onChanged(updated);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chartCard({
    required String title,
    required Widget child,
  }) {
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    final stats = [
      _summaryCard(
        title: '交易数量',
        value: placeholderTransactionCount.toString(),
        icon: Icons.receipt_long,
        color: Colors.deepOrange,
      ),
      _summaryCard(
        title: '总支出',
        value: '\$${placeholderExpense.toStringAsFixed(2)}',
        icon: Icons.arrow_downward,
        color: Colors.redAccent,
      ),
      _summaryCard(
        title: '总收入',
        value: '\$${placeholderIncome.toStringAsFixed(2)}',
        icon: Icons.arrow_upward,
        color: Colors.green,
      ),
      _summaryCard(
        title: '余额',
        value: '\$${placeholderBalance.toStringAsFixed(2)}',
        icon: Icons.account_balance_wallet,
        color: Colors.indigo,
      ),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        children: [
          // _monthSelector(),
          SizedBox(
            height: 12,
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: stats,
              )),
          const SizedBox(height: 8),
          _chartCard(
            title: '占位折线图',
            child: SizedBox(
              height: 230,
              child: PlaceholderLineChart(
                data: const [80, 110, 95, 140, 130, 160],
                labels: const ['1月', '2月', '3月', '4月', '5月', '6月'],
              ),
            ),
          ),
          _chartCard(
            title: '占位饼图',
            child: SizedBox(
              height: 200,
              child: PlaceholderPieChart(
                segments: const [
                  PieSegment('餐饮', 0.38, Colors.redAccent),
                  PieSegment('住房', 0.28, Colors.orange),
                  PieSegment('购物', 0.22, Colors.amber),
                  PieSegment('其他', 0.12, Colors.deepPurple),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Summary',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color(0xFFFF5A5A),
          elevation: 0,
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(48),
            child: TabBar(
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: [
                Tab(text: 'Week'),
                Tab(text: 'Month'),
                Tab(text: 'Year'),
              ],
            ),
          ),
        ),
        body: Container(
          color: const Color(0xFFFFF4F4),
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildTabContent(),
                      _buildTabContent(),
                      _buildTabContent(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
