import 'package:flutter/material.dart';
import 'package:my_bookkeeping/widgets/dual_direction_material.dart';
import 'package:my_bookkeeping/widgets/time_picker_sheet.dart';
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

  bool isStickHead = true;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      final pos = _scrollController.position;

      /// 到顶
      if (pos.pixels < 0) {
        if (isStickHead)
          setState(() {
            isStickHead = false;
          });
      } else if (pos.pixels >= pos.maxScrollExtent) {
        setState(() {
          isStickHead = true;
        });
      }
    });
  }

  void openTimePicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final appState = Provider.of<AppState>(context, listen: false);

        return FractionallySizedBox(
          heightFactor: 0.35,
          child: TimePickerSheet(
            isYear: true,
            isMonth: true,
            isDate: false,
            initialDate: appState.currentMonth,
            onConfirm: (date) {
              setState(() {
                appState.currentMonth = date;
              });
              print(date);
              // APIService().fetchMonthTransactions(appState.currentMonth);
              APIService().fetchLocalMonthTransactions(appState.currentMonth);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: true);

    Map<String, List> groupByDate(List transactions) {
      Map<String, List> grouped = {};

      for (var t in transactions) {
        String dateKey = formatDate(t['timestamp']);

        if (!grouped.containsKey(dateKey)) {
          grouped[dateKey] = [];
        }

        grouped[dateKey]!.add(t);
      }

      return grouped;
    }

    final grouped = groupByDate(appState.transactions);

    Future<void> loadNextMonth() async {
      final nextMonth = DateTime(
        appState.currentMonth.year,
        appState.currentMonth.month + 1,
      );

      final dtNow = DateTime.now();
      final dtEnd = DateTime(dtNow.year, dtNow.month + 1, 0, 23, 59, 59);
      if (nextMonth.millisecondsSinceEpoch > dtEnd.millisecondsSinceEpoch) {
        print('Latest month already');
        return;
      }

      appState.currentMonth = nextMonth;

      // await APIService().fetchMonthTransactions(appState.currentMonth);
      await APIService().fetchLocalMonthTransactions(appState.currentMonth);

      print('current month: ${appState.currentMonth}');
    }

    Future<void> loadPreviousMonth() async {
      appState.currentMonth = DateTime(
        appState.currentMonth.year,
        appState.currentMonth.month - 1,
      );

      // await APIService().fetchMonthTransactions(appState.currentMonth);
      await APIService().fetchLocalMonthTransactions(appState.currentMonth);

      print('current month: ${appState.currentMonth}');
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              '记账',
              style: TextStyle(
                  color: Colors.white, // 设置标题文字颜色
                  fontSize: 20, // 设置标题文字大小
                  fontWeight: FontWeight.bold), // 设置标题文字加粗
            ),
            SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: openTimePicker,
              child: Container(
                margin: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Color(0xFFFF5A5A),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  formatDateMonth(appState.currentMonth.millisecondsSinceEpoch),
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFFFF5A5A), // 设置AppBar背景颜色
      ),
      body: Container(
        color: const Color.fromARGB(255, 255, 223, 223),
        padding: EdgeInsets.all(0),
        child: Column(
          children: [
            Expanded(
                child: DualDirectionMaterialList(
              onRefreshUp: loadNextMonth,
              onRefreshDown: loadPreviousMonth,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                controller: _scrollController,
                slivers: [
                  ...grouped.entries.map((entry) {
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
                      sticky: isStickHead,
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, i) {
                            final t = items[i];

                            var category = categories.firstWhere(
                              (c) => c['name'] == t['category'],
                            );

                            return Container(
                              color: const Color.fromARGB(255, 255, 255, 255),
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
                                      t['note'],
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    t['amount'].toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            );
                          },
                          childCount: items.length,
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
