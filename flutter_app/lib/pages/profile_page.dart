import 'package:flutter/material.dart';
import 'package:my_bookkeeping/pages/contact_page.dart';
import 'package:my_bookkeeping/pages/login_page.dart';
import 'package:my_bookkeeping/pages/setttings_page.dart';
import 'package:my_bookkeeping/service/api_service.dart';
import 'package:my_bookkeeping/singleton/singleton.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:my_bookkeeping/utils/net_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_bookkeeping/utils/app_state.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();

  const ProfilePage({Key? key}) : super(key: key);
}

class _ProfilePageState extends State<ProfilePage> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    emailCtrl.text = Provider.of<AppState>(context, listen: false).email;
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final res = await NetService().httpPost('logout', {});

      final data = json.decode(res.body);

      if (data['ok'] != true) {
        print('Logout failed: ${data['error']}');
        // return;
      } else {
        print('Logout successful');
      }

      Global.appState.setTransactions([]);
      Global.appState.setPlans([]);
      Global.appState.clearSummaryCache();
      Global.appState.clearProfileStats();
      Global.appState.setMessage([]);

      await prefs.remove('token');
      await prefs.remove('userId');
      await prefs.remove('email');

      final db = Global.appDatabase;
      await db.delete(db.transactions).go(); // 清空表

      setState(() {
        emailCtrl.clear();
        passwordCtrl.clear();
        Provider.of<AppState>(context, listen: false).logout();
        NetService().setToken('');
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginPage()),
      );
    } catch (e) {
      print('logout error: $e');
    }
  }

  Widget _Card({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget profileWidget(BuildContext context) {
    final stats = [
      _Card(
        title: 'Streak',
        value: Global.appState.streak.toString(),
        icon: Icons.fireplace,
        color: Colors.deepOrange,
      ),
      _Card(
        title: 'Days',
        value: Global.appState.totalStreak.toString(),
        icon: Icons.search,
        color: Colors.redAccent,
      ),
      _Card(
        title: 'Entries',
        value: Global.appState.totalEntries.toString(),
        icon: Icons.receipt_rounded,
        color: Colors.green,
      ),
    ];

    Widget _SmallCard(
        {required String title,
        required IconData icon,
        required Future<void> Function() function}) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            backgroundColor: const Color.fromARGB(255, 255, 206, 194),
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          ),
          onPressed: () async {
            await function();
          },
          child: Column(
            children: [
              Icon(icon, color: Colors.red, size: 24),
              const SizedBox(height: 12),
              Text(title, style: TextStyle(fontSize: 10, color: Colors.black)),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: const Color.fromARGB(255, 255, 236, 236),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "My'Book'keeper",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(height: 2),
                    Text(
                      emailCtrl.text,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    GridView.count(
                      crossAxisCount: 3,
                      childAspectRatio: 0.85,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: stats,
                    ),
                  ],
                ),
              )),

          SizedBox(height: 6),

          Card(
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: const Color.fromARGB(255, 255, 236, 236),
              child: Padding(
                  padding: EdgeInsets.all(16),
                  child: GridView.count(
                    crossAxisCount: 3,
                    childAspectRatio: 1.2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      // 获取后端的数据并同步至本地数据库
                      _SmallCard(
                          title: 'Fetch Backup',
                          icon: Icons.backup_outlined,
                          function: () async => {
                                await APIService().fetchTransactionsAndSync(),
                                await APIService().fetchPlansAndSync()
                              }),

                      // 获取后端未同步的数据同步至本地数据库
                      _SmallCard(
                          title: 'Fetch Data',
                          icon: Icons.download_for_offline_outlined,
                          function: () async => {
                                await APIService().fetchUnsyncTransactions(),
                                APIService().fetchLocalMonthTransactions(
                                    Global.appState.currentMonth)
                              }),

                      // 同步本地数据至后端
                      _SmallCard(
                          title: 'Sync Data',
                          icon: Icons.sync,
                          function: () async => {
                                await APIService().syncUnsyncTransactions(),
                                await APIService().syncUnsyncPlans()
                              }),
                    ],
                  ))),

          // Contact
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.centerLeft,
                backgroundColor: const Color.fromARGB(255, 255, 236, 236),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ContactPage()),
                );
              },
              child: Text('Feedback',
                  style: TextStyle(fontSize: 16, color: Colors.black)),
            ),
          ),

          SizedBox(height: 12),

          // 登出按钮
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                alignment: Alignment.centerLeft,
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              ),
              onPressed: () {
                logout();
              },
              child: Text('Logout',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),

          // // Bug check button (临时)
          // SizedBox(
          //   width: double.infinity,
          //   child: ElevatedButton(
          //     style: ElevatedButton.styleFrom(
          //       alignment: Alignment.centerLeft,
          //       backgroundColor: Colors.red,
          //       padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          //     ),
          //     onPressed: () {
          //       Provider.of<AppState>(context, listen: false).checkVariables();
          //     },
          //     child: Text('Check',
          //         style: TextStyle(fontSize: 16, color: Colors.white)),
          //   ),
          // ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<AppState>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile',
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 6),
              child: IconButton(
                icon: const Icon(Icons.settings, color: Colors.white, size: 24),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SettingsPage()),
                  );
                },
              )),
        ],
        backgroundColor: Color(0xFFFF5A5A),
      ),
      body: profileWidget(context),
    );
  }
}
