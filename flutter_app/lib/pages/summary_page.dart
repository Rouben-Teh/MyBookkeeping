import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:my_bookkeeping/utils/app_state.dart';
import 'package:my_bookkeeping/utils/datetime.dart';
import 'package:my_bookkeeping/service/api_service.dart';
import 'package:my_bookkeeping/singleton/singleton.dart';
import 'package:provider/provider.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({super.key});

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late String _currentDateText = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 3, vsync: this, initialIndex: Global.appState.lastSummaryTab);
    _tabController.addListener(_onTabChanged);
    _updateCurrentDateText();
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      print('tab is changing index');
      Global.appState.setLastSummaryTab(_tabController.index);
      _updateCurrentDateText();
    }
  }

  void _updateCurrentDateText() {
    setState(() {
      switch (_tabController.index) {
        case 0:
          _currentDateText = _formatWeekRange(Global.appState.summaryWeekDate);
          break;
        case 1:
          _currentDateText =
              _formatMonthTitle(Global.appState.summaryMonthDate);
          break;
        case 2:
        default:
          _currentDateText = _formatYearTitle(Global.appState.summaryYearDate);
          break;
      }
    });
  }

  String _formatWeekRange(DateTime date) {
    final startOfWeek = date.subtract(Duration(days: date.weekday));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return '${startOfWeek.month}/${startOfWeek.day} - ${endOfWeek.month}/${endOfWeek.day}';
  }

  String _formatWeekRangeDay(DateTime date, int index) {
    if (index == 0) {
      return formatStartOfTheWeek(date);
    } else {
      return subsequentWeekDay(date, index);
    }
  }

  String _formatMonthTitle(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}';
  }

  String _formatYearTitle(DateTime date) {
    return '${date.year}';
  }

  void _changeDisplayDate(int delta) {
    setState(() {
      if (_tabController.index == 0) {
        DateTime newDt =
            Global.appState.summaryWeekDate.add(Duration(days: 7 * delta));
        Global.appState.summaryWeekDate = newDt;
        setWeekSummary(newDt);
      } else if (_tabController.index == 1) {
        DateTime newDt = DateTime(
          Global.appState.summaryMonthDate.year,
          Global.appState.summaryMonthDate.month + delta,
          Global.appState.summaryMonthDate.day,
        );
        Global.appState.summaryMonthDate = newDt;
        setMonthSummary(newDt);
      } else {
        DateTime newDt = DateTime(
          Global.appState.summaryYearDate.year + delta,
          Global.appState.summaryYearDate.month,
          Global.appState.summaryYearDate.day,
        );
        Global.appState.summaryYearDate = newDt;
        setYearSummary(newDt);
      }
      _updateCurrentDateText();
    });
  }

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

  List<Map<String, dynamic>> _normalizeTransactionList(dynamic transaction) {
    if (transaction is List) {
      return transaction.whereType<Map<String, dynamic>>().toList();
    }
    return [];
  }

  double _parseAmount(dynamic amount) {
    if (amount is num) return amount.toDouble();
    if (amount is String) return double.tryParse(amount) ?? 0.0;
    return 0.0;
  }

  DateTime _transactionDate(Map<String, dynamic> transaction) {
    final timestamp = transaction['timestamp'];
    if (timestamp is int) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    if (timestamp is String) {
      final value = int.tryParse(timestamp);
      if (value != null) {
        return DateTime.fromMillisecondsSinceEpoch(value);
      }
    }
    return DateTime.now();
  }

  List<DateTime> _buildAxisDates(
      DateTime start, DateTime end, bool groupByMonth) {
    if (groupByMonth) {
      final year = start.year;
      return List.generate(12, (index) => DateTime(year, index + 1, 1));
    }

    final days = end.difference(start).inDays + 1;
    return List.generate(
        days, (index) => DateTime(start.year, start.month, start.day + index));
  }

  List<String> _buildAxisLabels(List<DateTime> axisDates, bool groupByMonth) {
    if (axisDates.isEmpty) return [];

    // Year view: axisDates will be 12 entries (one per month)
    if (axisDates.length == 12) {
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return axisDates.map((date) => months[date.month - 1]).toList();
    }

    // Month view: more than 7 entries -> show day numbers (1..N)
    if (axisDates.length > 7) {
      return axisDates.map((date) {
        final day = date.day;

        return (day == 1 || day % 5 == 0) ? day.toString() : '';
      }).toList();
    }

    // Week view: show weekday short names Sun..Sat
    const weekNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return axisDates.map((date) => weekNames[date.weekday % 7]).toList();
  }

  List<double> _buildSeriesValues(
    List<Map<String, dynamic>> transactions,
    List<DateTime> axisDates,
    String type,
    bool groupByMonth,
  ) {
    final totals = {for (final date in axisDates) date: 0.0};

    for (final transaction in transactions) {
      if (transaction['deleted'] == 1) continue;
      if (transaction['type'] != type) continue;

      final txDate = _transactionDate(transaction);
      final key = groupByMonth
          ? DateTime(txDate.year, txDate.month, 1)
          : DateTime(txDate.year, txDate.month, txDate.day);
      if (totals.containsKey(key)) {
        totals[key] = totals[key]! + _parseAmount(transaction['amount']);
      }
    }

    return axisDates.map((date) => totals[date] ?? 0.0).toList();
  }

  Widget _buildLineChart(List<Map<String, dynamic>> transactions) {
    final currentIndex = _tabController.index;
    final weekRange = getWeekStartEnd(Global.appState.summaryWeekDate);
    final monthRange = getMonthStartEnd(Global.appState.summaryMonthDate);
    final yearRange = getYearStartEnd(Global.appState.summaryYearDate);

    final groupByMonth = currentIndex == 2;
    final start = DateTime.fromMillisecondsSinceEpoch(
      currentIndex == 0
          ? weekRange['start']!
          : currentIndex == 1
              ? monthRange['start']!
              : yearRange['start']!,
    );
    final end = DateTime.fromMillisecondsSinceEpoch(
      currentIndex == 0
          ? weekRange['end']!
          : currentIndex == 1
              ? monthRange['end']!
              : yearRange['end']!,
    );

    final axisDates = _buildAxisDates(start, end, groupByMonth);
    final labels = _buildAxisLabels(axisDates, groupByMonth);
    final expenseSeries =
        _buildSeriesValues(transactions, axisDates, 'expense', groupByMonth);
    final incomeSeries =
        _buildSeriesValues(transactions, axisDates, 'income', groupByMonth);

    final maxY = <double>[...expenseSeries, ...incomeSeries]
        .fold(0.0, (prev, value) => value > prev ? value : prev);
    final topY = maxY < 1 ? 1.0 : maxY * 1.2;

    final minX = 0.0;
    final maxX = axisDates.isNotEmpty ? (axisDates.length - 1).toDouble() : 0.0;

    return LineChart(
      LineChartData(
        minX: minX,
        maxX: maxX,
        minY: 0,
        maxY: topY,
        gridData: FlGridData(
            show: true, drawVerticalLine: false, horizontalInterval: topY / 4),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= labels.length) {
                  return const SizedBox.shrink();
                }
                return SideTitleWidget(
                  meta: meta,
                  child:
                      Text(labels[index], style: const TextStyle(fontSize: 10)),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: topY / 4,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return SideTitleWidget(
                  meta: meta,
                  child: Text('\$${value.toInt()}',
                      style: const TextStyle(fontSize: 10)),
                );
              },
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            fitInsideHorizontally: true,
            tooltipBorderRadius: BorderRadius.circular(8),
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              int index = 0;
              return touchedBarSpots.map((barSpot) {
                index++;
                final flSpot = barSpot;

                TextAlign textAlign = switch (flSpot.x.toInt()) {
                  0 => TextAlign.left,
                  6 => TextAlign.right,
                  _ => TextAlign.center,
                };

                return LineTooltipItem(
                  index == 1
                      ? _tabController.index == 0
                          ? '${_formatWeekRangeDay(Global.appState.summaryWeekDate, flSpot.x.toInt())}\n'
                          : '${_currentDateText}-${flSpot.x.toInt() + 1}\n'
                      : '',
                  TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text:
                          '${flSpot.bar.color == Colors.redAccent ? 'Expenses' : 'Income'}\n',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(
                      text: '\$',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    TextSpan(
                      text: flSpot.y.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                  textAlign: textAlign,
                );
              }).toList();
            },
            getTooltipColor: (touchedSpot) =>
                Colors.white.withValues(alpha: 0.8),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
              expenseSeries.length,
              (index) => FlSpot(index.toDouble(), expenseSeries[index]),
            ),
            isCurved: true,
            color: Colors.redAccent,
            barWidth: 3,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(
                show: true, color: Colors.redAccent.withValues(alpha: 0.15)),
          ),
          LineChartBarData(
            spots: List.generate(
              incomeSeries.length,
              (index) => FlSpot(index.toDouble(), incomeSeries[index]),
            ),
            isCurved: true,
            color: Colors.green,
            barWidth: 3,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(
                show: true, color: Colors.green.withValues(alpha: 0.15)),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryPieChart(List<Map<String, dynamic>> transactions) {
    final totals = <String, double>{};

    for (final transaction in transactions) {
      if (transaction['deleted'] == 1) continue;
      if (transaction['type'] == 'income') continue;
      final category = transaction['category']?.toString() ?? 'Other';
      totals[category] =
          (totals[category] ?? 0) + _parseAmount(transaction['amount']);
    }

    final entries = totals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final visibleEntries = entries.take(5).toList();
    final othersTotal =
        entries.skip(5).fold(0.0, (sum, entry) => sum + entry.value);
    if (othersTotal > 0) {
      visibleEntries.add(MapEntry('Others', othersTotal));
    }

    final totalAmount =
        visibleEntries.fold(0.0, (sum, entry) => sum + entry.value);
    if (totalAmount == 0) {
      return const Center(child: Text('No category data available'));
    }

    const colors = [
      Colors.redAccent,
      Colors.orange,
      Colors.amber,
      Colors.deepPurple,
      Colors.teal,
      Colors.blueGrey,
    ];

    final sections = List.generate(
      visibleEntries.length,
      (index) {
        final entry = visibleEntries[index];
        final percent =
            totalAmount == 0 ? 0.0 : entry.value / totalAmount * 100;
        return PieChartSectionData(
          color: colors[index % colors.length],
          value: entry.value,
          title: '${percent.toStringAsFixed(0)}%',
          radius: 42,
          titleStyle: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
        );
      },
    );

    return Row(
      children: [
        SizedBox(
          width: 150,
          height: 150,
          child: PieChart(
            PieChartData(
              sections: sections,
              centerSpaceRadius: 30,
              sectionsSpace: 4,
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: visibleEntries.map((entry) {
              final index = visibleEntries.indexOf(entry);
              final color = colors[index % colors.length];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                            color: color, shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Text(
                            '${entry.key} (${entry.value.toStringAsFixed(2)})')),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTabContent(dynamic transaction) {
    final txList = _normalizeTransactionList(transaction);
    double totalExpensesAmount = 0.0;
    double totalIncomeAmount = 0.0;

    void count(List<Map<String, dynamic>> list) {
      for (var t in list) {
        if (t['deleted'] != 1) {
          final amount = _parseAmount(t['amount']);
          if (t['type'] == 'expense') {
            totalExpensesAmount += amount;
          } else if (t['type'] == 'income') {
            totalIncomeAmount += amount;
          }
        }
      }
    }

    count(txList);

    final stats = [
      _summaryCard(
        title: 'Transactions',
        value: transaction.length.toString(),
        icon: Icons.receipt_long,
        color: Colors.deepOrange,
      ),
      _summaryCard(
        title: 'Total expenses',
        value: '\$${totalExpensesAmount.toStringAsFixed(2)}',
        icon: Icons.arrow_downward,
        color: Colors.redAccent,
      ),
      _summaryCard(
        title: 'Total income',
        value: '\$${totalIncomeAmount.toStringAsFixed(2)}',
        icon: Icons.arrow_upward,
        color: Colors.green,
      ),
      _summaryCard(
        title: 'Balance',
        value:
            '\$${(totalIncomeAmount - totalExpensesAmount).toStringAsFixed(2)}',
        icon: Icons.account_balance_wallet,
        color: Colors.indigo,
      ),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 12, bottom: 24),
      child: Column(
        children: [
          // _monthSelector(),
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
            title: 'Income & Expenses',
            child: SizedBox(
              height: 230,
              child: _buildLineChart(txList),
            ),
          ),
          _chartCard(
            title: 'Expenses by Category',
            child: SizedBox(
              height: 240,
              child: _buildCategoryPieChart(txList),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<AppState>(context, listen: true);

    final yearTransaction = Global.appState.summaryCache.firstWhere(
      (item) => item['key'] == 'year',
      orElse: () => {'transaction': []},
    )['transaction'];
    final monthTransaction = Global.appState.summaryCache.firstWhere(
      (item) => item['key'] == 'month',
      orElse: () => {'transaction': []},
    )['transaction'];
    final weekTransaction = Global.appState.summaryCache.firstWhere(
      (item) => item['key'] == 'week',
      orElse: () => {'transaction': []},
    )['transaction'];

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
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: TabBar(
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              controller: _tabController,
              tabs: const [
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
                Container(
                  height: 30,
                  color: const Color.fromARGB(255, 255, 185, 185),
                  child: Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            _changeDisplayDate(-1);
                          },
                          child: Container(
                            color: const Color.fromARGB(0, 255, 255, 255),
                            width: 50,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 6),
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Color.fromARGB(255, 255, 255, 255),
                              size: 16,
                            ),
                          )),
                      Expanded(
                          child: Text(
                        _currentDateText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      )),
                      GestureDetector(
                          onTap: () {
                            _changeDisplayDate(1);
                          },
                          child: Container(
                            color: const Color.fromARGB(0, 255, 255, 255),
                            width: 50,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 6),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Color.fromARGB(255, 255, 255, 255),
                              size: 16,
                            ),
                          )),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildTabContent(weekTransaction),
                      _buildTabContent(monthTransaction),
                      _buildTabContent(yearTransaction),
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

Future<void> setYearSummary(DateTime dt) async {
  final yearDt = getYearStartEnd(dt);
  final yearTransaction = await APIService()
      .fetchLocalTimeRangeTransactions(yearDt['start']!, yearDt['end']!);
  Global.appState.setSummaryCache(
      'year', yearDt['start']!, yearDt['end']!, yearTransaction);
}

Future<void> setMonthSummary(DateTime dt) async {
  final monthDt = getMonthStartEnd(dt);
  final monthTransaction = await APIService()
      .fetchLocalTimeRangeTransactions(monthDt['start']!, monthDt['end']!);
  Global.appState.setSummaryCache(
      'month', monthDt['start']!, monthDt['end']!, monthTransaction);
}

Future<void> setWeekSummary(DateTime dt) async {
  final weekDt = getWeekStartEnd(dt);
  final weekTransaction = await APIService()
      .fetchLocalTimeRangeTransactions(weekDt['start']!, weekDt['end']!);
  Global.appState.setSummaryCache(
      'week', weekDt['start']!, weekDt['end']!, weekTransaction);
}
