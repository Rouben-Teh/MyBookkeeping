import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:my_bookkeeping/utils/app_session.dart';

class NetService {
  static String token = '';

  void setToken(String t) {
    token = t;

    if (token.isNotEmpty) {
      AppSession.init();
    } else {
      AppSession.resetInit();
    }
  }

  Future<http.Response> httpPost(String api, Map<String, dynamic> body,
      {int timeout = 5}) async {
    try {
      final response = await http
          .post(
            Uri.parse('http://10.0.2.2:8000/api.php?action=$api'),
            headers: {
              'Content-Type': 'application/json',
              if (token.isNotEmpty) 'authorization': 'Bearer $token'
            },
            body: json.encode(body),
          )
          .timeout(Duration(seconds: timeout));

      return response;
    } catch (e) {
      print('httppost error:$e');
      return http.Response(
        '{"ok":false,"reason":"Server offline"}',
        500,
      );
    }
  }
}
