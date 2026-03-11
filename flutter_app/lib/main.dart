import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'singleton/singleton.dart';
import 'pages/splash_page.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (_) => Global.appState,
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '记账示例',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SplashPage(),
    );
  }
}
