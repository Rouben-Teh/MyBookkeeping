import 'dart:convert';

import 'package:my_bookkeeping/service/api_service.dart';
import 'package:my_bookkeeping/singleton/singleton.dart';
import 'package:my_bookkeeping/enum/enum.dart';

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
      if (his['sender'] == 'human') {
        Global.appState.addMessage(ChatMessage(
          content: his['response'],
          isUser: true,
        ));
      } else {
        final parseRes = json.decode(his['response']);
        Global.appState.addMessage(ChatMessage(
          content: parseRes['content'] != null ? parseRes['content'] : '',
          isUser: false,
        ));
      }
    }
  }
}
