import 'package:flutter/material.dart';

import 'package:my_bookkeeping/pages/record_details_page.dart';
import 'package:my_bookkeeping/pages/record_page.dart';
import 'package:my_bookkeeping/pages/profile_page.dart';
import 'package:my_bookkeeping/pages/chat_page.dart';
import 'package:my_bookkeeping/pages/summary_page.dart';
import 'package:my_bookkeeping/pages/plans.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final pages = [
    RecordDetailsPage(),
    PlansPage(),
    SummaryPage(),
    ProfilePage(),
  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
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
              backgroundColor: Color(0xFFFF5A5A),
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
            IconButton(
                icon: Icon(Icons.savings, color: Colors.black),
                onPressed: () {
                  setState(() {
                    currentIndex = 0;
                  });
                }),
            IconButton(
                icon: Icon(Icons.event_note, color: Colors.black),
                onPressed: () {
                  setState(() {
                    currentIndex = 1;
                  });
                }),
            SizedBox(width: 40), // 给中间按钮留空间
            IconButton(
                icon: Icon(Icons.bar_chart, color: Colors.black),
                onPressed: () {
                  setState(() {
                    currentIndex = 2;
                  });
                }),
            IconButton(
                icon: Icon(Icons.person, color: Colors.black),
                onPressed: () {
                  setState(() {
                    currentIndex = 3;
                  });
                }),
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
          backgroundColor: Color(0xFFFF5A5A), // 设置按钮背景颜色
          shape: CircleBorder(),
        ),
      ),

      // 按钮位置居中
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
