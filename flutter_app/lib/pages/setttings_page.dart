import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_bookkeeping/service/settings_service.dart';
import 'package:my_bookkeeping/service/api_service.dart';
import 'package:my_bookkeeping/utils/app_state.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Widget buildColorMenu() {
    final appState = Provider.of<AppState>(context, listen: true);
    return PopupMenuButton<Color>(
      onSelected: (color) {
        APIService().updateSettings(jsonEncode({
          'theme_color': colorOptions.indexOf(color),
          'currency': appState.selectedCurrency
        }));
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
            color: appState.selectedLightColor,
            margin: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              title: Text('Current color：${colorNames[appState.selectedColor]}',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
              trailing: Icon(Icons.color_lens, color: appState.selectedColor),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCurrencyMenu() {
    final appState = Provider.of<AppState>(context, listen: true);
    return PopupMenuButton<String>(
      onSelected: (currency) {
        APIService().updateSettings(jsonEncode({
          'theme_color': colorOptions.indexOf(appState.selectedColor),
          'currency': currency
        }));
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
            color: appState.selectedLightColor,
            margin: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              title: Text('Current currency：${appState.selectedCurrency}',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
              trailing:
                  Icon(Icons.currency_exchange, color: appState.selectedColor),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: appState.selectedColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildColorMenu(),
            buildCurrencyMenu(),
            // SizedBox(height: 20),
            // Card(
            //   shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(10)),
            //   color: appState.selectedColor,
            //   child: Padding(
            //     padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text('Current style：Color',
            //             style: TextStyle(
            //                 fontSize: 16, fontWeight: FontWeight.bold)),
            //         SizedBox(height: 12),
            //         Text(
            //             'Click the button above to switch to different styles, and click here to open the secondary menu to select a color.',
            //             style: TextStyle(fontSize: 16, color: Colors.black87)),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
