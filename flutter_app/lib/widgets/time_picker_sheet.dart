import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class TimePickerSheet extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime) onConfirm;

  const TimePickerSheet({
    Key? key,
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
          title: const Text("选择时间"),
          backgroundColor: const Color(0xFFFF5A5A),
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
                                  "$year 年",
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ))
                          .toList(),
                    ),
                  ),

                  // 月份滚轮
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
                                  "$month 月",
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ))
                          .toList(),
                    ),
                  ),

                  // 日滚轮
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
                                  "$day 日",
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
                child: const Text("确定"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
