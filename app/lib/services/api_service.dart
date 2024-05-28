import 'dart:convert';
import 'package:app/screens/members/components/user.dart';
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
      return jsonDecode(response.body);
    } else {
      throw 'Failed to login';
    }
  }

  static Future<void> logout(String sessionKey) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/logout'),
      headers: <String, String>{
        'Authorization': basicAuth,
        'auth': sessionKey,
      },
    );

    if (response.statusCode == 200) {
      // Logout successful
      return;
    } else {
      throw 'Failed to logout';
    }
  }

  static Future<Map<String, dynamic>> getMember(String sessionKey) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/member?session_key=$sessionKey'),
      headers: <String, String>{
        'Authorization': basicAuth,
        'Content-Type': 'application/json; charset=UTF-8',
        'auth': sessionKey
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw 'Failed to get member';
    }
  }

  static Future<List<User>> getMembers(String sessionKey) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/members'),
      headers: <String, String>{
        'Authorization': basicAuth,
        'Content-Type': 'application/json; charset=UTF-8',
        'auth': sessionKey
      },
    );

    if (response.statusCode == 200) {
      // Parse the response body into a list of User objects
      final List<dynamic> responseData = jsonDecode(response.body);
      final List<User> users = responseData
          .map((data) => User(
              name: data['name'],
              nickname: data['nickname'],
              credits: data['credits']))
          .toList();
      return users;
    } else {
      throw 'Failed to get members';
    }
  }

static Future<void> addMember(String name, String mail, String phoneNumber, String secret) async {
  // Define the API endpoint
  final String apiUrl = '$baseUrl/api/addmember';

  // Prepare the request body
  Map<String, dynamic> data = {
    'name': name,
    'mail': mail,
    'phonenumber': phoneNumber,
    'secret': secret,
  };

  try {
    // Convert the request body to JSON format
    String requestBody = json.encode(data);

    // Make an HTTP POST request to the server
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Authorization': basicAuth,
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: requestBody, // Send the request body
    );

    // Check if the request was successful (status code 200)
    if (response.statusCode == 200) {
      // Member added successfully
      print('Member added successfully');
    } else {
      // Handle error response
      print('Failed to add member: ${response.statusCode}');
    }
  } catch (e) {
    // Handle network errors
    print('Error adding member: $e');
  }
}


  static Future<String> getRole(String sessionKey) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/getRole'), // Replace with your API endpoint
      headers: {
        'Authorization': basicAuth,
        'Content-Type': 'application/json; charset=UTF-8',
        'auth': sessionKey,
      },
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['role']; // Adjust based on your API response structure
    } else {
      throw Exception('Failed to load role');
    }
  }
}
