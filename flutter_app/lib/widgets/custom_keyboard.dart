import 'package:flutter/material.dart';
import 'package:my_bookkeeping/utils/app_state.dart';
import 'package:provider/provider.dart';

class CustomKeyboard extends StatelessWidget {
  final Function(String) onKeyTap;
  final VoidCallback onDelete;
  final VoidCallback onAdd;
  final VoidCallback onEdit;
  final VoidCallback onTime;
  final VoidCallback onPlus;
  final VoidCallback onMinus;
  final VoidCallback onEqual;
  final bool isCalculatorMode;
  final bool isEdit;
  final DateTime selectedDate;

  const CustomKeyboard({
    Key? key,
    required this.onKeyTap,
    required this.onDelete,
    required this.onAdd,
    required this.onEdit,
    required this.onTime,
    required this.onPlus,
    required this.onMinus,
    required this.onEqual,
    required this.isCalculatorMode,
    required this.isEdit,
    required this.selectedDate,
  }) : super(key: key);

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Widget buildButton(String text, {Color? color, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap ?? () => onKeyTap(text),
      child: Container(
        margin: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color ?? Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
              fontSize: text.length > 6 ? 16 : 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: true);
    return Container(
      height: 350,
      padding: EdgeInsets.all(10),
      child: GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true, // 让GridView适应内容高度
        physics: NeverScrollableScrollPhysics(), // 禁止滚动
        children: [
          // 第一排
          buildButton('1'),
          buildButton('2'),
          buildButton('3'),
          buildButton(
              isSameDay(selectedDate, DateTime.now())
                  ? 'Today'
                  : '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}',
              color: appState.selectedColor,
              onTap: onTime),

          // 第二排
          buildButton('4'),
          buildButton('5'),
          buildButton('6'),
          buildButton('+', color: appState.selectedColor, onTap: onPlus),

          // 第三排
          buildButton('7'),
          buildButton('8'),
          buildButton('9'),
          buildButton('-', color: appState.selectedColor, onTap: onMinus),

          // 第四排
          buildButton('.'),
          buildButton('0'),
          buildButton('⌫', onTap: onDelete),
          buildButton(
              isCalculatorMode
                  ? '='
                  : isEdit
                      ? 'Edit'
                      : 'Add',
              color: appState.selectedColor,
              onTap: isCalculatorMode
                  ? onEqual
                  : isEdit
                      ? onEdit
                      : onAdd)
        ],
      ),
    );
  }
}
