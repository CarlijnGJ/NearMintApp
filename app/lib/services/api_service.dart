import 'dart:convert';
import 'package:app/components/customexception.dart';
import 'package:http/http.dart' as http;

class APIService {
  static const String baseUrl =
      'http://localhost:3000'; // Replace this with your API base URL

  static Future<Map<String, dynamic>> login(
      String nickname, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'nickname': nickname,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 400) {
      throw HttpExceptionWithStatusCode(
          'Incorrect username and password combination', 400);
    } else {
      throw 'Connection failed';
    }
  }

  static Future<void> logout(String sessionKey) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/logout'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
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

  static Future<List<Map<String, dynamic>>> getMembers(
      String sessionKey) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/members'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'auth': sessionKey
      },
    );

    if (response.statusCode == 200) {
      // Parse the response body into a list of Map<String, dynamic>
      final List<dynamic> responseData = jsonDecode(response.body);
      final List<Map<String, dynamic>> members = responseData
          .map((data) => {
                'memberId': data['member_id'], // Add member ID to the map
                'name': data['name'],
                'nickname': data['nickname'],
                'credits': data['credits']
              })
          .toList();
      return members;
    } else {
      throw Exception('Failed to get members');
    }
  }

  static Future<void> addMember(
      String name, String mail, String phoneNumber, String secret) async {
    // Define the API endpoint
    const String apiUrl = '$baseUrl/api/addmember';

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

  static Future<dynamic> checkCode(String code) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/member/code'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Code': code,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return CodeInfo.fromJson(data);
    } else {
      throw Exception('Failed to check code');
    }
  }

  static Future<void> updateMember(String code, String nickname,
      String password, String avatar, String gender, String prefgame) async {
    Map<String, dynamic> initData = {
      'code': code,
      'nickname': nickname,
      'password': password,
      'avatar': avatar,
      'gender': gender,
      'prefgame': prefgame
    };

    final response = await http.post(
      Uri.parse('$baseUrl/api/updatemember'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(initData),
    );

    if (response.statusCode == 200) {
      print("Registration complete.");
    } else {
      throw Exception("Couldn't move data");
    }
  }

  static Future<dynamic> keepSessionAlive(String sessionKey) async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/api/keepSessionKeyAlive'), // Replace with your API endpoint
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'auth': sessionKey,
      },
    );

    if (response.statusCode == 201) {
      return true; // User is active and keeps being logged in
    } else {
      return false; // User is inactive and is logged out
    }
  }

  static Future<List<dynamic>> getTransactions(String sessionKey) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/getTransactions'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'auth': sessionKey,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data[
          'transactions']; // Assuming transactions are returned as a list from the API
    } else {
      throw Exception('Failed to get transactions');
    }
  }

  static Future<void> addTransaction(int memberId, double amount,
      String description, String date, String sessionKey) async {
    // Define the API endpoint
    const String apiUrl = '$baseUrl/api/addTransaction';

    // Prepare the request body
    Map<String, dynamic> data = {
      'member_id': memberId, // Use member ID instead of session key
      'amount': amount,
      'description': description,
      'date': date,
    };

    try {
      // Convert the request body to JSON format
      String requestBody = json.encode(data);

      // Make an HTTP POST request to the server
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'auth': sessionKey, // Include the session key in the headers
        },
        body: requestBody, // Send the request body
      );

      // Check if the request was successful (status code 201)
      if (response.statusCode == 201) {
        print('Transaction added successfully');
      } else {
        // Handle error response
        print('Failed to add transaction: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      // Handle network errors
      print('Error adding transaction: $e');
    }
  }
}

//Needed for checkCode, needs to be moved or recoded
class CodeInfo {
  final bool result;
  final String name;

  CodeInfo({required this.result, required this.name});

  factory CodeInfo.fromJson(Map<String, dynamic> json) {
    return CodeInfo(
      result: json['result'],
      name: json['name'],
    );
  }
}
