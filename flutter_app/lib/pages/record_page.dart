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

class _RecordPageState extends State<RecordPage>
    with SingleTickerProviderStateMixin {
  final _categoryCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final TabController _tabController;

  DateTime _date = DateTime.now();

  InputMode _mode = InputMode.normal;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    if (widget.data != null) {
      _tabController.index = widget.data['type'] == 'expense' ? 0 : 1;
      _categoryCtrl.text = widget.data['category'] ?? '';
      _amountCtrl.text = widget.data['amount'].toString();
      _noteCtrl.text = widget.data['note'] ?? '';
      _date = DateTime.fromMillisecondsSinceEpoch(widget.data['timestamp']);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Column(children: [
          TabBar(
            indicatorColor: const Color.fromARGB(255, 255, 88, 113),
            labelColor: const Color.fromARGB(255, 255, 88, 113),
            unselectedLabelColor: const Color.fromARGB(179, 66, 66, 66),
            controller: _tabController,
            tabs: const [
              Tab(text: 'Expense'),
              Tab(text: 'Income'),
            ],
          ),
          Container(
            padding: EdgeInsets.all(12),
            height: MediaQuery.of(context).size.height * 0.83,
            child: Column(
              // verticalDirection: VerticalDirection.up, // 从下往上排列
              // give the grid a bounded height so it can scroll
              // mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: TabBarView(controller: _tabController, children: [
                    CategoryPage(
                      scrollController: _scrollController,
                      isExpense: true,
                      selectedCategory: _categoryCtrl.text,
                      onKeyTap: (categoryName) {
                        print('Selected category: $categoryName');
                        setState(() {
                          _categoryCtrl.text = categoryName; // 将选中的类别名称设置到备注输入框
                        });
                      },
                      jumpItemIndex: widget.jumpItemIndex,
                    ),
                    CategoryPage(
                      scrollController: _scrollController,
                      isExpense: false,
                      selectedCategory: _categoryCtrl.text,
                      onKeyTap: (categoryName) {
                        print('Selected category: $categoryName');
                        setState(() {
                          _categoryCtrl.text = categoryName; // 将选中的类别名称设置到备注输入框
                        });
                      },
                      // jumpItemIndex: widget.jumpItemIndex, //Second page doesn't need jump index otherwise it will jump to the category when editing income record
                    ),
                  ]),
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
                                decoration: InputDecoration(
                                  labelText: 'Note',
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 255, 79,
                                          79), // Your desired focus color
                                      width: 2.0, // Optional thickness change
                                    ),
                                  ),
                                )),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            flex: 1,
                            child: TextField(
                                readOnly: true,
                                controller: _amountCtrl,
                                keyboardType: TextInputType.none,
                                decoration: InputDecoration(
                                  labelText: 'Amount',
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 255, 79,
                                          79), // Your desired focus color
                                      width: 2.0, // Optional thickness change
                                    ),
                                  ),
                                )),
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
                                'Adding transaction: ${_tabController.index == 0 ? 'expense' : 'income'} ${_categoryCtrl.text}, ${_amountCtrl.text}, ${_noteCtrl.text}, ${_date.millisecondsSinceEpoch}');
                            APIService().addLocalTransaction(
                                _tabController.index == 0
                                    ? 'expense'
                                    : 'income',
                                _categoryCtrl.text,
                                _amountCtrl.text,
                                _noteCtrl.text,
                                _date, (data) {
                              _categoryCtrl.clear();
                              _amountCtrl.clear();
                              _noteCtrl.clear();
                              Navigator.pop(context);
                            });
                          },
                          onEdit: () {
                            print(
                                'Editing transaction: ${_tabController.index == 0 ? 'expense' : 'income'} ${_categoryCtrl.text}, ${_amountCtrl.text}, ${_noteCtrl.text}, ${_date.millisecondsSinceEpoch},  ${widget.data['createdAt']}');
                            APIService().editLocalTransactions({
                              'id': widget.data['id'],
                              'type': _tabController.index == 0
                                  ? 'expense'
                                  : 'income',
                              'category': _categoryCtrl.text,
                              'amount':
                                  double.tryParse(_amountCtrl.text) ?? 0.0,
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
                                final result =
                                    evaluateExpression(_amountCtrl.text);
                                _amountCtrl.text = result.toString();
                                setState(() {
                                  _mode = InputMode.normal; // 删除后回到普通输入模式
                                });
                              } catch (e) {
                                print('Calculation error: $e');
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
          ),
        ]));
  }
}
