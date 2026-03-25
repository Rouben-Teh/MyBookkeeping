import 'package:flutter/material.dart';
import 'package:my_bookkeeping/service/api_service.dart';
import 'package:my_bookkeeping/widgets/custom_expense_category.dart';
import 'package:my_bookkeeping/widgets/custom_keyboard.dart';
import 'package:my_bookkeeping/widgets/time_picker_sheet.dart';
import 'package:my_bookkeeping/utils/calculator.dart';

class RecordBottomSheet {
  static void open(BuildContext context, {dynamic data, int? jumpItemIndex}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.9,
        child: RecordPage(
          data: data,
          jumpItemIndex: jumpItemIndex,
        ),
      ),
    );
  }
}

class RecordPage extends StatefulWidget {
  final dynamic data;
  final int? jumpItemIndex;

  const RecordPage({
    super.key,
    this.data,
    this.jumpItemIndex,
  });

  @override
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  final _categoryCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  DateTime _date = DateTime.now();

  InputMode _mode = InputMode.normal;

  @override
  void initState() {
    super.initState();

    if (widget.data != null) {
      _categoryCtrl.text = widget.data['category'] ?? '';
      _amountCtrl.text = widget.data['amount'].toString();
      _noteCtrl.text = widget.data['note'] ?? '';
      _date = DateTime.fromMillisecondsSinceEpoch(widget.data['timestamp']);
    }
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
              scrollController: _scrollController,
              selectedCategory: _categoryCtrl.text,
              onKeyTap: (categoryName) {
                print('Selected category: $categoryName');
                setState(() {
                  _categoryCtrl.text = categoryName; // 将选中的类别名称设置到备注输入框
                });
              },
              jumpItemIndex: widget.jumpItemIndex,
            ),
          ),
          _categoryCtrl.text.isEmpty
              ? SizedBox.shrink()
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 12),
                    Expanded(
                      flex: 3,
                      child: TextField(
                          controller: _noteCtrl,
                          decoration: InputDecoration(labelText: '备注')),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      flex: 1,
                      child: TextField(
                          readOnly: true,
                          controller: _amountCtrl,
                          keyboardType: TextInputType.none,
                          decoration: InputDecoration(labelText: '金额')),
                    ),
                    SizedBox(width: 12),
                  ],
                ),
          SizedBox(height: 8),
          _categoryCtrl.text.isEmpty
              ? SizedBox.shrink()
              : SizedBox(
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
                      print(
                          '添加交易: ${_categoryCtrl.text}, ${_amountCtrl.text}, ${_noteCtrl.text}, ${_date.millisecondsSinceEpoch}');
                      APIService().addLocalTransaction(_categoryCtrl.text,
                          _amountCtrl.text, _noteCtrl.text, _date, (data) {
                        _categoryCtrl.clear();
                        _amountCtrl.clear();
                        _noteCtrl.clear();
                        Navigator.pop(context);
                      });
                    },
                    onEdit: () {
                      print(
                          '修改交易: ${_categoryCtrl.text}, ${_amountCtrl.text}, ${_noteCtrl.text}, ${_date.millisecondsSinceEpoch},  ${widget.data['createdAt']}');
                      APIService().editLocalTransactions({
                        'id': widget.data['id'],
                        'category': _categoryCtrl.text,
                        'amount': double.tryParse(_amountCtrl.text) ?? 0.0,
                        'note': _noteCtrl.text,
                        'timestamp': _date.millisecondsSinceEpoch,
                        'created_at': widget.data['createdAt'],
                      }, (data) {
                        _categoryCtrl.clear();
                        _amountCtrl.clear();
                        _noteCtrl.clear();
                        Navigator.pop(context);
                      });
                    },
                    onTime: () {
                      TimePickerBottomSheet.open(
                          context, _date, true, true, true,
                          onConfirm: (date) => {
                                setState(() {
                                  _date = date;
                                })
                              });
                    },
                    onPlus: () {
                      if (_mode == InputMode.operator) {
                        _amountCtrl.text = _amountCtrl.text
                            .substring(0, _amountCtrl.text.length - 1);
                      }
                      _amountCtrl.text += '+';
                      setState(() {
                        _mode = InputMode.operator; // 进入计算器模式
                      });
                    },
                    onMinus: () {
                      if (_mode == InputMode.operator) {
                        _amountCtrl.text = _amountCtrl.text
                            .substring(0, _amountCtrl.text.length - 1);
                      }
                      _amountCtrl.text += '-';
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
                    isEdit: widget.jumpItemIndex != null,
                    selectedDate: _date,
                  ),
                )
        ],
      ),
    );
  }
}
