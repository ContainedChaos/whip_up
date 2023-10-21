import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:whip_up/Screens/Login/login_screen.dart';

class VerifyScreen extends StatefulWidget {
  final String userId;

  VerifyScreen({required this.userId});

  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final TextEditingController otpController = TextEditingController();

  void verify() async {
    final response = await http.post(
      Uri.parse('http://192.168.0.103:8000/verify-otp/'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'user_id': widget.userId,
        'token': otpController.text,
      }),
    );
    print('Response: ${response.body}');

    if (response.statusCode == 200) {
      // Verification successful, show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('OTP verified successfully'),
          backgroundColor: Colors.green, // Set the background color for success
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    } else if (response.statusCode == 400) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You have entered the wrong OTP'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      // Verification failed, show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('OTP verification failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Account'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Enter OTP received in your email'),
            TextField(
              controller: otpController,
              decoration: InputDecoration(labelText: 'OTP'),
            ),
            Text('User ID: ${widget.userId}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: verify,
              child: Text('Verify'),
            ),
          ],
        ),
      ),
    );
  }
}
