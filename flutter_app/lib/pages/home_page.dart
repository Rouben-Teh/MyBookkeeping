import 'package:flutter/material.dart';

import 'package:my_bookkeeping/pages/record_details_page.dart';
import 'package:my_bookkeeping/pages/record_page.dart';
import 'package:my_bookkeeping/pages/profile_page.dart';
import 'package:my_bookkeeping/pages/chat_page.dart';
import 'package:my_bookkeeping/pages/summary_page.dart';
import 'package:my_bookkeeping/pages/plan_page.dart';
import 'package:my_bookkeeping/service/profile_service.dart';
import 'package:my_bookkeeping/utils/app_state.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    ProfileStats();
  }

  final pages = [
    RecordDetailsPage(),
    PlansPage(),
    SummaryPage(),
    ProfilePage(),
  ];

  int currentIndex = 0;

  Widget button(int index, IconData icon) {
    final appState = Provider.of<AppState>(context, listen: true);
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: currentIndex == index
            ? appState.selectedColor
            : const Color.fromARGB(0, 255, 255, 255),
        shape: BoxShape.circle,
      ),
      child: IconButton(
          icon: Icon(icon,
              color: currentIndex == index
                  ? Colors.white
                  : appState.selectedColor),
          onPressed: () {
            setState(() {
              currentIndex = index;
            });
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: true);
    return Scaffold(
      body: Stack(
        children: [
          pages[currentIndex],
          // 右下角聊天悬浮按钮
          Positioned(
            width: 50,
            height: 50,
            right: 20,
            bottom: 20,
            child: FloatingActionButton(
              heroTag: 'chatbot',
              mini: true,
              shape: CircleBorder(),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ChatPage()),
                );
              },
              backgroundColor: appState.selectedColor,
              child: Icon(Icons.chat, color: Colors.white),
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(), // 中间挖洞
        notchMargin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            button(0, Icons.savings),
            button(1, Icons.event_note),
            SizedBox(width: 40), // 给中间按钮留空间
            button(2, Icons.bar_chart),
            button(3, Icons.person),
          ],
        ),
        color: Color.fromARGB(255, 255, 252, 252),
        shadowColor: const Color.fromARGB(255, 94, 94, 94),
      ),

      // 中间圆形大按钮
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          heroTag: 'add',
          onPressed: () => RecordBottomSheet.open(context), // 打开底部抽屉
          child: Icon(Icons.add, size: 30, color: Colors.white),
          backgroundColor: appState.selectedColor, // 设置按钮背景颜色
          shape: CircleBorder(),
        ),
      ),

      // 按钮位置居中
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
