import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'app_state.dart';

class NetService {
  static String? token;

  void setToken(String t) {
    token = t;
  }

  Future<http.Response> httpPost(String api, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api.php?action=$api'),
      headers: {
        'Content-Type': 'application/json',
        if (token!.isNotEmpty) "authorization": "Bearer $token"
      },
      body: json.encode(body),
    );

    return response;
  }
}
