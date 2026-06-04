import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:my_bookkeeping/utils/app_state.dart';
import 'package:my_bookkeeping/service/api_service.dart';

class TimePickerBottomSheet {
  static void open(
      BuildContext context, DateTime dt, bool year, bool month, bool date,
      {required Function(DateTime) onConfirm}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final appState = Provider.of<AppState>(context, listen: false);

        return FractionallySizedBox(
          heightFactor: 0.35,
          child: TimePickerSheet(
            isYear: year,
            isMonth: month,
            isDate: date,
            initialDate: dt,
            onConfirm: (date) {
              onConfirm(date);
              print(date);
              APIService().fetchLocalMonthTransactions(appState.currentMonth);
            },
          ),
        );
      },
    );
  }
}

class TimePickerSheet extends StatefulWidget {
  final bool isYear;
  final bool isMonth;
  final bool isDate;
  final DateTime initialDate;
  final Function(DateTime) onConfirm;

  const TimePickerSheet({
    Key? key,
    required this.isYear,
    required this.isMonth,
    required this.isDate,
    required this.initialDate,
    required this.onConfirm,
  }) : super(key: key);

  @override
  State<TimePickerSheet> createState() => _TimePickerSheetState();
}

class _TimePickerSheetState extends State<TimePickerSheet> {
  late int selectedYear;
  late int selectedMonth;
  late int selectedDay;

  final List<int> years =
      List.generate(50, (index) => 2000 + index); // 2000~2049
  final List<int> months = List.generate(12, (index) => index + 1); // 1~12
  final List<int> days = List.generate(31, (index) => index + 1); // 1~31

  @override
  void initState() {
    super.initState();

    selectedYear = widget.initialDate.year;
    selectedMonth = widget.initialDate.month;
    selectedDay = widget.initialDate.day;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Select time'),
          backgroundColor: const Color(0xFFFF5A5A),
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  // 年份滚轮
                  if (this.widget.isYear)
                    Expanded(
                      child: CupertinoPicker(
                        itemExtent: 40,
                        scrollController: FixedExtentScrollController(
                          initialItem: years.indexOf(selectedYear),
                        ),
                        onSelectedItemChanged: (index) {
                          setState(() {
                            selectedYear = years[index];
                          });
                        },
                        children: years
                            .map((year) => Center(
                                  child: Text(
                                    '$year',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),

                  // 月份滚轮
                  if (this.widget.isMonth)
                    Expanded(
                      child: CupertinoPicker(
                        itemExtent: 40,
                        scrollController: FixedExtentScrollController(
                          initialItem: months.indexOf(selectedMonth),
                        ),
                        onSelectedItemChanged: (index) {
                          setState(() {
                            selectedMonth = months[index];
                          });
                        },
                        children: months
                            .map((month) => Center(
                                  child: Text(
                                    '$month',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),

                  // 日滚轮
                  if (this.widget.isDate)
                    Expanded(
                      child: CupertinoPicker(
                        itemExtent: 40,
                        scrollController: FixedExtentScrollController(
                          initialItem: days.indexOf(selectedDay),
                        ),
                        onSelectedItemChanged: (index) {
                          setState(() {
                            selectedDay = days[index];
                          });
                        },
                        children: days
                            .map((day) => Center(
                                  child: Text(
                                    '$day Day',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5A5A),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  final result =
                      DateTime(selectedYear, selectedMonth, selectedDay);
                  widget.onConfirm(result);
                  Navigator.pop(context);
                },
                child: const Text('Confirm',
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
