import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Color selectedColor = Colors.red;

  final List<Color> colorOptions = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange
  ];
  final Map<Color, String> colorNames = {
    Colors.red: 'Red',
    Colors.green: 'Green',
    Colors.blue: 'Blue',
    Colors.orange: 'Orange',
  };

  Widget buildColorMenu() {
    return PopupMenuButton<Color>(
      onSelected: (color) {
        setState(() {
          selectedColor = color;
        });
      },
      itemBuilder: (context) {
        return colorOptions.map((color) {
          return PopupMenuItem<Color>(
            value: color,
            child: Row(
              children: [
                Container(
                  width: 18,
                  height: 18,
                  decoration:
                      BoxDecoration(color: color, shape: BoxShape.circle),
                ),
                SizedBox(width: 12),
                Text(colorNames[color] ?? ''),
              ],
            ),
          );
        }).toList();
      },
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Card(
            color: const Color.fromARGB(255, 255, 236, 236),
            margin: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              title: Text('Current color：${colorNames[selectedColor]}',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
              trailing: Icon(Icons.color_lens, color: selectedColor),
            ),
          ),
        ),
      ),
    );
  }

  String selectedCurrency = '\$';

  final List<String> currencyOptions = ['RM', '\$', '￥'];

  Widget buildCurrencyMenu() {
    return PopupMenuButton<String>(
      onSelected: (currency) {
        setState(() {
          selectedCurrency = currency;
        });
      },
      itemBuilder: (context) {
        return currencyOptions.map((currency) {
          return PopupMenuItem<String>(
            value: currency,
            child: Row(
              children: [
                Text(currency),
              ],
            ),
          );
        }).toList();
      },
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Card(
            color: const Color.fromARGB(255, 255, 236, 236),
            margin: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              title: Text('Current currency：${selectedCurrency}',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
              trailing: Icon(Icons.currency_exchange, color: selectedColor),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: Color(0xFFFF5A5A),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildColorMenu(),
            buildCurrencyMenu(),
            SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: const Color.fromARGB(255, 255, 236, 236),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Current style：Color',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 12),
                    Text(
                        'Click the button above to switch to different styles, and click here to open the secondary menu to select a color.',
                        style: TextStyle(fontSize: 16, color: Colors.black87)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
