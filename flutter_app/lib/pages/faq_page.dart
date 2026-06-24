import 'package:flutter/material.dart';
import 'package:my_bookkeeping/singleton/singleton.dart';
import 'package:my_bookkeeping/utils/app_state.dart';
import 'dart:convert';
import 'package:my_bookkeeping/utils/net_utils.dart';
import 'package:provider/provider.dart';

class FAQPage extends StatefulWidget {
  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  Future<void> faq() async {
    try {
      final res = await NetService().httpPost('faq', {});
      final data = json.decode(res.body);
      print(data['faq']);
      if (data['faq'] != null) {
        Global.appState.setFAQ(data['faq']);
      }
    } catch (e) {
      print('post error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    faq();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQ',
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        backgroundColor: appState.selectedColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: appState.faqCache == [] || appState.faqCache.isEmpty
            ? Center(
                child: Text('There are currently no FAQ',
                    style: TextStyle(fontSize: 16, color: Colors.black54)),
              )
            : ListView.builder(
                itemCount: appState.faqCache.length,
                itemBuilder: (context, index) {
                  final data = appState.faqCache[index];
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ExpansionTile(
                      collapsedShape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      collapsedBackgroundColor: appState.selectedLightColor,
                      backgroundColor: appState.selectedLightColor,
                      tilePadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      title: Text(
                        data['title'] ?? '',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              data['content'] ?? '',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black87),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
