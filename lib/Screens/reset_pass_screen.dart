import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:whip_up/Screens/Login/login_screen.dart';

class ResetPasswordScreen extends StatelessWidget {
  final String email;
  ResetPasswordScreen({required this.email});

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController otpController = TextEditingController();

  void submitNewPassword(BuildContext context) async {
    String newPassword = newPasswordController.text;
    String confirmPassword = confirmPasswordController.text;
    String otp = otpController.text;

    List<String> errorMessages = [];

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    RegExp passwordRegExp = RegExp(
      r"^(?=.*[A-Z])(?=.*[0-9])[a-zA-Z0-9]{6,}$",
    );

    if (newPassword.isEmpty) {
      errorMessages.add('Password is required.');
    } else if (!passwordRegExp.hasMatch(newPassword)) {
      errorMessages.add(
        'Password must be at least 6 characters long and contain at least 1 capital letter and 1 digit.',
      );
    }

    if (otp.isEmpty) {
      errorMessages.add('OTP is required.');
    }

    if (errorMessages.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessages.join('\n')),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://192.168.0.103:8000/reset-password/'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'email': email,
          'newPassword': newPassword,
          'otp': otp,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password reset successful'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to reset password'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(),
              ),
            ),
            TextField(
              controller: otpController,
              decoration: InputDecoration(
                labelText: 'OTP',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => submitNewPassword(context),
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
