import 'package:flutter/material.dart';
import 'package:my_bookkeeping/pages/record_page.dart';
import 'package:my_bookkeeping/singleton/singleton.dart';
import 'package:my_bookkeeping/widgets/dual_direction_material.dart';
import 'package:my_bookkeeping/widgets/time_picker_sheet.dart';
import 'package:provider/provider.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:my_bookkeeping/utils/app_state.dart';
import 'package:my_bookkeeping/enum/enum.dart';
import 'package:my_bookkeeping/utils/datetime.dart';
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

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: true);

    double totalExpensesAmount = 0.0;
    double totalIncomeAmount = 0.0;

    Map<String, List> groupByDate(List transactions) {
      Map<String, List> grouped = {};

      for (var t in transactions) {
        if (t['deleted'] != 1) {
          if (t['type'] == 'expense') {
            totalExpensesAmount += t['amount'];
          } else if (t['type'] == 'income') {
            totalIncomeAmount += t['amount'];
          }
        }

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
      await APIService().fetchUnsyncTransactions();

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
      await APIService().fetchUnsyncTransactions();

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
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownMenu<String>(
              inputDecorationTheme: InputDecorationTheme(
                border: InputBorder.none,
              ),
              textStyle: TextStyle(
                  color: Colors.white, // 设置标题文字颜色
                  fontSize: 20, // 设置标题文字大小
                  fontWeight: FontWeight.bold), // 设置标题文字加粗
              menuStyle: MenuStyle(
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.hovered)) {
                    return appState.selectedColor;
                  }
                  return const Color.fromARGB(255, 255, 255, 255);
                }),
              ),
              initialSelection:
                  Global.appState.type == 'expense' ? 'expense' : 'income',
              dropdownMenuEntries: const [
                DropdownMenuEntry(value: 'expense', label: 'Expenses'),
                DropdownMenuEntry(value: 'income', label: 'Income'),
              ],
              onSelected: (value) {
                appState.setType(value!);
                print(value);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => TimePickerBottomSheet.open(
                      context, appState.currentMonth, true, true, false,
                      onConfirm: (date) {
                    setState(() {
                      appState.currentMonth = date;
                    });
                  }),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 0, vertical: 6),
                    decoration: BoxDecoration(
                      color: appState.selectedColor.withValues(alpha: 0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      formatDateMonth(
                          appState.currentMonth.millisecondsSinceEpoch),
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                Text(
                  'Total: ${appState.selectedCurrency}${appState.type == 'expense' ? totalExpensesAmount.toStringAsFixed(2) : totalIncomeAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ],
        ),
        backgroundColor: appState.selectedColor, // 设置AppBar背景颜色
        toolbarHeight: 100,
      ),
      body: Container(
        color: appState.selectedColor.withValues(alpha: 0.2),
        padding: EdgeInsets.all(0),
        child: Column(
          children: [
            Expanded(
                child: SlidableAutoCloseBehavior(
                    child: DualDirectionMaterialList(
              onRefreshUp: loadNextMonth,
              onRefreshDown: loadPreviousMonth,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                controller: _scrollController,
                slivers: [
                  ...grouped.entries.where((entry) {
                    return entry.value.any(
                      (item) => item['type'] == appState.type,
                    );
                  }).map((entry) {
                    final date = entry.key;
                    final items = entry.value;

                    return SliverStickyHeader(
                      header: Container(
                        height: 40,
                        color: appState.selectedColor.withValues(alpha: 0.15),
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

                            if (t['type'] != appState.type) {
                              return SizedBox.shrink();
                            }

                            var entry =
                                ExpenseCategories.asMap().entries.firstWhere(
                                      (e) => e.value['name'] == t['category'],
                                      orElse: () => MapEntry(-1, {
                                        'name': 'Unknown',
                                        'icon': Icons.help,
                                      }),
                                    );

                            int index = entry.key;
                            var category = entry.value;
                            // print('Category: $category, Index: $index');

                            return Slidable(
                              key: ValueKey(t['id']),

                              // 👉 左滑
                              endActionPane: ActionPane(
                                motion: ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) {
                                      print(t);
                                      RecordBottomSheet.open(context,
                                          data: t, jumpItemIndex: index);
                                    },
                                    backgroundColor: Colors.green,
                                    icon: Icons.edit,
                                  ),
                                  SlidableAction(
                                    onPressed: (context) {
                                      bool isRestored = false;

                                      APIService()
                                          .markDeleteLocalTransactions(t, true);

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              Text('Deleted ${t['category']}'),
                                          duration: const Duration(seconds: 3),
                                          persist: false,
                                          behavior:
                                              SnackBarBehavior.floating, // 可选
                                          action: SnackBarAction(
                                            label: 'Undo',
                                            onPressed: () {
                                              isRestored = true;

                                              APIService()
                                                  .markDeleteLocalTransactions(
                                                      t, false);
                                              print('restore');
                                            },
                                          ),
                                        ),
                                      );

                                      // 3️⃣ 可选：延迟真正删除（比如 API）
                                      Future.delayed(const Duration(seconds: 3),
                                          () {
                                        if (!isRestored) {
                                          APIService().syncUnsyncTransactions();
                                        }
                                      });
                                    },
                                    backgroundColor: Colors.red,
                                    icon: Icons.delete,
                                  ),
                                ],
                              ),

                              child: Container(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                height: 70,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: appState.selectedColor
                                            .withValues(alpha: 0.7),
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
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
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
            ))),
          ],
        ),
      ),
    );
  }
}
