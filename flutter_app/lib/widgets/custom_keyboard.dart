import 'package:flutter/material.dart';

class CustomKeyboard extends StatelessWidget {
  final Function(String) onKeyTap;
  final VoidCallback onDelete;
  final VoidCallback onAdd;
  final VoidCallback onTime;
  final VoidCallback onPlus;
  final VoidCallback onMinus;
  final VoidCallback onEqual;
  final bool isCalculatorMode;

  const CustomKeyboard({
    Key? key,
    required this.onKeyTap,
    required this.onDelete,
    required this.onAdd,
    required this.onTime,
    required this.onPlus,
    required this.onMinus,
    required this.onEqual,
    required this.isCalculatorMode,
  }) : super(key: key);

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
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      padding: EdgeInsets.all(10),
      child: GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true, // 让GridView适应内容高度
        physics: NeverScrollableScrollPhysics(), // 禁止滚动
        children: [
          // 第一排
          buildButton("1"),
          buildButton("2"),
          buildButton("3"),
          buildButton("时间", color: Color(0xFFFF5A5A), onTap: onTime),

          // 第二排
          buildButton("4"),
          buildButton("5"),
          buildButton("6"),
          buildButton("+", color: Color(0xFFFF5A5A), onTap: onPlus),

          // 第三排
          buildButton("7"),
          buildButton("8"),
          buildButton("9"),
          buildButton("-", color: Color(0xFFFF5A5A), onTap: onMinus),

          // 第四排
          buildButton("."),
          buildButton("0"),
          buildButton("⌫", onTap: onDelete),
          buildButton(isCalculatorMode ? "=" : "添加",
              color: Color(0xFFFF5A5A),
              onTap: isCalculatorMode ? onEqual : onAdd)
        ],
      ),
    );
  }
}
