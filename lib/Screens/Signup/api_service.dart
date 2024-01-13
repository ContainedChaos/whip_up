import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../model/user.dart';

class ApiService {
  final String baseUrl =
      'http://192.168.0.107:8000'; // Replace with your server address

  Future<Map<String, dynamic>> signup(
      String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('http://192.168.0.107:8000/signup/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
          {'username': username, 'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      print("welcome");
      print(json.decode(response.body));
      return jsonDecode(response.body);
    } else if (response.statusCode == 409) {
      // Handle conflict (Customer Exists) error here
      return {'message': 'Customer Exists'};
    } else {
      throw Exception('Failed to signup');
    }
  }

// login

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('http://192.168.0.107:8000/login/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      // print('Error response: ${response.body}');
      return jsonDecode(response.body);
    }
  }

  // edit user profile
  Future<void> editUserProfile(String originalEmail, String newUsername, String imageUrl, String bio) async {
    print(originalEmail);
    print(newUsername);
    final response = await http.put(
      Uri.parse('http://192.168.0.107:8000/profile/$originalEmail/'),  // Adjusted the URL here
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'originalEmail': originalEmail,
        'username': newUsername,
        'imageUrl': imageUrl,
        'bio': bio,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to edit profile');
    }
  }

  // fetch user profile
  Future<User> fetchUserProfile(String email) async {
    final response = await http.get(
      Uri.parse('http://192.168.0.107:8000/profile/$email/'),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load profile');
    }
  }
}
