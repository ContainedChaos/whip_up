import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:whip_up/Screens/Login/login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  ResetPasswordScreen({required this.email});

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

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
        Uri.parse('http://192.168.1.103:8000/reset-password/'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'email': widget.email,
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
        backgroundColor: Colors.grey.shade900,
      ),
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            buildPasswordTextField(
              newPasswordController,
              'New Password',
              _obscureNewPassword,
                  () => togglePasswordVisibility('new'),
            ),
            SizedBox(height: 16.0),
            buildPasswordTextField(
              confirmPasswordController,
              'Confirm Password',
              _obscureConfirmPassword,
                  () => togglePasswordVisibility('confirm'),
            ),
            SizedBox(height: 16.0),
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
              style: ElevatedButton.styleFrom(
                primary: Colors.grey.shade900, // Change the button color to grey
                padding: EdgeInsets.all(16),
              ),
              child: Text(
                'Submit',
                style: TextStyle(
                  fontSize: 14, // Increase the font size
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPasswordTextField(
      TextEditingController controller,
      String labelText,
      bool obscureText,
      VoidCallback toggleVisibility,
      ) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: toggleVisibility,
        ),
      ),
    );
  }

  void togglePasswordVisibility(String field) {
    setState(() {
      if (field == 'new') {
        _obscureNewPassword = !_obscureNewPassword;
      } else if (field == 'confirm') {
        _obscureConfirmPassword = !_obscureConfirmPassword;
      }
    });
  }
}
