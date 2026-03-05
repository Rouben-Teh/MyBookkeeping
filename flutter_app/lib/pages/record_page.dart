import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../widgets/custom_expense_category.dart';
import '../widgets/custom_keyboard.dart';
import '../widgets/time_picker_sheet.dart';
import '../utils/calculator.dart';

class RecordPage extends StatefulWidget {
  @override
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  DateTime _date = DateTime.now();

  InputMode _mode = InputMode.normal;

  Future<void> addTransaction() async {
    final amount = double.tryParse(_amountCtrl.text) ?? 0.0;
    final note = _noteCtrl.text;
    try {
      await http.post(Uri.parse('http://10.0.2.2:8000/api.php?action=add'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'amount': amount, 'note': note, 'date': _date}));
      _amountCtrl.clear();
      _noteCtrl.clear();
      // fetchTransactions();
    } catch (e) {
      print('post error: $e');
    }
  }

  void openTimePicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.35,
          child: TimePickerSheet(
            initialDate: _date,
            onConfirm: (date) {
              setState(() {
                _date = date;
              });
              print(date);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        // verticalDirection: VerticalDirection.up, // 从下往上排列
        // give the grid a bounded height so it can scroll
        // mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: CategoryPage(
              onKeyTap: (categoryName) {
                print('Selected category: $categoryName');
                _noteCtrl.text = categoryName; // 将选中的类别名称设置到备注输入框
              },
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: TextField(
                    controller: _noteCtrl,
                    decoration: InputDecoration(labelText: '备注')),
              ),
              Expanded(
                flex: 1,
                child: TextField(
                    readOnly: true,
                    controller: _amountCtrl,
                    keyboardType: TextInputType.none,
                    decoration: InputDecoration(labelText: '金额')),
              )
            ],
          ),
          SizedBox(height: 8),
          SizedBox(
            height: 390, // 固定高度
            child: CustomKeyboard(
              onKeyTap: (key) {
                _amountCtrl.text += key;
              },
              onDelete: () {
                if (_amountCtrl.text.isNotEmpty) {
                  _amountCtrl.text = _amountCtrl.text
                      .substring(0, _amountCtrl.text.length - 1);

                  if (_mode == InputMode.operator) {
                    setState(() {
                      _mode = InputMode.normal; // 删除后回到普通输入模式
                    });
                  }
                }
              },
              onAdd: () {
                addTransaction();
              },
              onTime: () {
                openTimePicker();
              },
              onPlus: () {
                if (_mode == InputMode.operator) {
                  _amountCtrl.text = _amountCtrl.text
                      .substring(0, _amountCtrl.text.length - 1);
                }
                _amountCtrl.text += "+";
                setState(() {
                  _mode = InputMode.operator; // 进入计算器模式
                });
              },
              onMinus: () {
                if (_mode == InputMode.operator) {
                  _amountCtrl.text = _amountCtrl.text
                      .substring(0, _amountCtrl.text.length - 1);
                }
                _amountCtrl.text += "-";
                setState(() {
                  _mode = InputMode.operator; // 进入计算器模式
                });
              },
              onEqual: () {
                if (_mode == InputMode.operator) {
                  try {
                    final result = evaluateExpression(_amountCtrl.text);
                    _amountCtrl.text = result.toString();
                    setState(() {
                      _mode = InputMode.normal; // 删除后回到普通输入模式
                    });
                  } catch (e) {
                    print('计算错误: $e');
                  }
                }
              },
              isCalculatorMode: _mode == InputMode.operator,
              selectedDate: _date,
            ),
          )
        ],
      ),
    );
  }
}
