import 'package:flutter/material.dart';

class CustomKeyboard extends StatelessWidget {
  final Function(String) onKeyTap;
  final VoidCallback onDelete;
  final VoidCallback onAdd;
  final VoidCallback onTime;
  final VoidCallback onPlus;
  final VoidCallback onMinus;

  const CustomKeyboard({
    Key? key,
    required this.onKeyTap,
    required this.onDelete,
    required this.onAdd,
    required this.onTime,
    required this.onPlus,
    required this.onMinus,
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
        children: [
          // 第一排
          buildButton("1"),
          buildButton("2"),
          buildButton("3"),
          buildButton("⌫", color: Colors.orange, onTap: onDelete),

          // 第二排
          buildButton("4"),
          buildButton("5"),
          buildButton("6"),
          buildButton("+", color: Colors.blue, onTap: onPlus),

          // 第三排
          buildButton("7"),
          buildButton("8"),
          buildButton("9"),
          buildButton("-", color: Colors.blue, onTap: onMinus),

          // 第四排
          buildButton("时间", color: Colors.purple, onTap: onTime),
          buildButton("0"),
          buildButton("."),
          buildButton("添加", color: Colors.green, onTap: onAdd),
        ],
      ),
    );
  }
}
