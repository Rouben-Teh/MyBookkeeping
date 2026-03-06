import 'package:flutter/material.dart';

import 'record_details_page.dart';
import 'record_page.dart';
import 'profile_page.dart';

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

  Future<void> _openBottomDrawer(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 可控制高度
      // backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.9,
          child: RecordPage(),
        );
      },
    );
  }

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
          onPressed: () => _openBottomDrawer(context), // 打开底部抽屉
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
