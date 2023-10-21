import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl =
      'http://localhost:8000'; // Replace with your server address

  // Future<void> signup(String email, String password) async {

  //   final response = await http.post(
  //   Uri.parse('http://localhost:8000/signup/'),
  //   headers: <String, String>{
  //     'Content-Type': 'application/json; charset=UTF-8',
  //   },
  //   body: jsonEncode({'email': email, 'password': password}),
  // );

  //   print("welcome");
  //   print(json.decode(response.body));

  // }

//   Future<Map<String, dynamic>> signup(String email, String password) async {
//   try {
//     final response = await http.post(
//       Uri.parse('http://localhost:8000/signup/'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode({'email': email, 'password': password}),
//     );

//     if (response.statusCode == 200) { // Success status code
//       print("welcome");
//       print(json.decode(response.body));
//       return json.decode(response.body);
//     } else {
//       // Handle server-side error
//       throw Exception('Failed to signup: ${response.body}');
//     }
//   } catch (e) {
//     print('Error during signup: $e');
//     // You can throw the error again if you want the caller to know about it
//     throw Exception('Failed to signup due to a network error.');
//   }
// }

  Future<Map<String, dynamic>> signup(
      String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('http://192.168.0.104:8000/signup/'),
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
      Uri.parse('http://192.168.0.104:8000/login/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Error response: ${response.body}');
      throw Exception('Failed to login. Please try again.');
    }
  }
}
