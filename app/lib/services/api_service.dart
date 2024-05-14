import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String username = dotenv.env['API_USERNAME']!;
final String password = dotenv.env['API_PASSWORD']!;
String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

class APIService {
  static const String baseUrl =
      'http://localhost:3000'; // Replace this with your API base URL
  static Future<Map<String, dynamic>> login(
      String nickname, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/login'),
      headers: <String, String>{
        'Authorization': basicAuth,
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'nickname': nickname,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      print('Login successful');
      return jsonDecode('');
      //return jsonDecode(response.body);
    } else {
      throw 'Failed to login';
    }
  }
}
