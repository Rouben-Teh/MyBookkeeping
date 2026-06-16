import 'dart:convert';

import 'package:my_bookkeeping/service/api_service.dart';
import 'package:my_bookkeeping/singleton/singleton.dart';
import 'package:my_bookkeeping/enum/enum.dart';

//the class is for open another thread in order to avoid spend too much time on some task in main thread
class AppSession {
  static bool _initialized = false;

  static void resetInit() {
    _initialized = false;
  }

  static Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    await callAPI();
  }

  static Future<void> callAPI() async {
    print('get chat hostory');
    final histories = await APIService().getChatHistory();

    for (final his in histories) {
      if (his['role'] == 'human') {
        Global.appState.addMessage(ChatMessage(
          content: his['content'],
          isUser: true,
        ));
      } else {
        final parseRes = json.decode(his['content']);
        Global.appState.addMessage(ChatMessage(
          content: parseRes['content'] != null ? parseRes['content'] : '',
          isUser: false,
        ));
      }
    }
  }
}
