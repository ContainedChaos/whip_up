import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:whip_up/Screens/reset_pass_screen.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final BuildContext context;

  ForgotPasswordScreen(this.context);

  void sendOTP(BuildContext context) async {
    String email = emailController.text;

    print(email);

    final response = await http.post(
      Uri.parse('http://192.168.1.103:8000/send-otp/'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'email': email,
      }),
    );

    print('Response: ${response.body}');

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('OTP sent successfully'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to ResetPasswordScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResetPasswordScreen(email: email),
        ),
      );
    } else if (response.statusCode == 409) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You have not registered with this email.'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send OTP'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
        backgroundColor: Colors.grey.shade900,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30), // Add padding here
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Enter your email',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => sendOTP(context),
              style: ElevatedButton.styleFrom(
                primary: Colors.grey.shade900, // Change the button color to grey
                padding: EdgeInsets.all(16), // Add padding to the button
              ),
              child: Text(
                'Send OTP',
                style: TextStyle(
                  fontSize: 14, // Increase the font size
                  // You can set other text styles here if needed
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
