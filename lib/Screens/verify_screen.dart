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
      Uri.parse('http://192.168.0.114:8000/verify-otp/'),
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
        backgroundColor: Colors.grey.shade900,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 250),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 60.0), // Adjust the padding as needed
              child: TextField(
                controller: otpController,
                decoration: InputDecoration(
                  labelText: 'Enter OTP received in your email',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: verify,
              child: Text('Verify'),
              style: ElevatedButton.styleFrom(
                primary: Colors.grey.shade900, // Change the button color to grey
                minimumSize: Size(100, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
