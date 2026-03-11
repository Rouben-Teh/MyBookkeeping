import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import '../utils/app_state.dart';
import '../enum/enum.dart';
import '../utils/datetime.dart';
import 'package:my_bookkeeping/service/api_service.dart';

class RecordDetailsPage extends StatefulWidget {
  @override
  _RecordDetailsPageState createState() => _RecordDetailsPageState();
}

class _RecordDetailsPageState extends State<RecordDetailsPage> {
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    final appState = Provider.of<AppState>(context, listen: false);

    void loadNextMonth() async {
      _isLoading = true;
      final nextMonth = DateTime(
        appState.currentMonth.year,
        appState.currentMonth.month + 1,
      );

      final dtNow = DateTime.now();
      final dtEnd = DateTime(dtNow.year, dtNow.month + 1, 0, 23, 59, 59);
      if (nextMonth.millisecondsSinceEpoch > dtEnd.millisecondsSinceEpoch) {
        _isLoading = false;
        print("Latest month already");
        return;
      }

      appState.currentMonth = nextMonth;

      await APIService().fetchMonthTransactions(appState.currentMonth);
      _isLoading = false;
    }

    void loadPreviousMonth() async {
      _isLoading = true;
      appState.currentMonth = DateTime(
        appState.currentMonth.year,
        appState.currentMonth.month - 1,
      );

      await APIService().fetchMonthTransactions(appState.currentMonth);
      _isLoading = false;
    }

    _scrollController.addListener(() {
      final pos = _scrollController.position;

      /// 到底
      if (!_isLoading && pos.pixels >= pos.maxScrollExtent) {
        loadPreviousMonth();
        print("previous month");
      }

      /// 到顶
      if (!_isLoading && pos.pixels <= 1) {
        loadNextMonth();
        print("next month");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: true);

    Map<String, List> groupByDate(List transactions) {
      Map<String, List> grouped = {};

      for (var t in transactions) {
        String dateKey = formatDate(int.parse(t["timestamp"]));

        if (!grouped.containsKey(dateKey)) {
          grouped[dateKey] = [];
        }

        grouped[dateKey]!.add(t);
      }

      return grouped;
    }

    final grouped = groupByDate(appState.transactions);

    return Scaffold(
      appBar: AppBar(
        title: Text('记账',
            style: TextStyle(
                color: Colors.white, // 设置标题文字颜色
                fontSize: 20, // 设置标题文字大小
                fontWeight: FontWeight.bold)), // 设置标题文字加粗
        backgroundColor: Color(0xFFFF5A5A), // 设置AppBar背景颜色
      ),
      body: Padding(
        padding: EdgeInsets.all(0),
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                controller: _scrollController,
                slivers: grouped.entries.map((entry) {
                  final date = entry.key;
                  final items = entry.value;

                  return SliverStickyHeader(
                    header: Container(
                      height: 40,
                      color: const Color.fromARGB(255, 255, 223, 223),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        date,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, i) {
                          final t = items[i];

                          var category = categories.firstWhere(
                            (c) => c["name"] == t['category'],
                          );

                          return Container(
                            height: 70,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 255, 103, 103),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    category['icon'] as IconData,
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    t["note"],
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  t["amount"].toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 10),
                                Text(formatDate(int.parse(t['timestamp'])))
                              ],
                            ),
                          );
                        },
                        childCount: items.length,
                      ),
                    ),
                  );
                }).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
