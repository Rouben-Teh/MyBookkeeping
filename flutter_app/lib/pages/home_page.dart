import 'package:flutter/material.dart';

import 'package:my_bookkeeping/pages/record_details_page.dart';
import 'package:my_bookkeeping/pages/record_page.dart';
import 'package:my_bookkeeping/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final pages = [
    RecordDetailsPage(),
    ProfilePage(),
  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],

      // 底部导航栏
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(), // 中间挖洞
        notchMargin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                icon: Icon(Icons.bar_chart, color: Colors.black),
                onPressed: () {
                  setState(() {
                    currentIndex = 0;
                  });
                }),
            SizedBox(width: 40), // 给中间按钮留空间
            IconButton(
                icon: Icon(Icons.person, color: Colors.black),
                onPressed: () {
                  setState(() {
                    currentIndex = 1;
                  });
                }),
          ],
        ),
        color: Color.fromARGB(255, 255, 252, 252), // 设置底部导航栏背景颜色
        shadowColor: const Color.fromARGB(255, 94, 94, 94),
      ),

      // 中间圆形大按钮
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: FloatingActionButton(
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
