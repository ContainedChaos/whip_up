import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whip_up/Screens/Home/presentation/home_screen.dart';
import 'package:whip_up/Screens/Login/components/background.dart';
import 'package:whip_up/Screens/Signup/signup_screen.dart';
import 'package:whip_up/Screens/forgot_pass_screen.dart';
import 'package:whip_up/components/already_have_an_account_check.dart';
import 'package:whip_up/components/rounded_button.dart';
import 'package:whip_up/components/rounded_input_field.dart';
import 'package:whip_up/components/rounded_password_field.dart';
import 'package:whip_up/Screens/Signup/api_service.dart';
import 'package:whip_up/Screens/Welcome/welcome_screen.dart';
import 'package:whip_up/services/auth_service.dart';
import 'package:whip_up/views/screens/home_page.dart';

import '../../../views/screens/page_switcher.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String _email = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView( // Wrap with SingleChildScrollView
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "LogIn",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Colors.yellow.shade50,
              ),
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            RoundedInputField(
              hintText: "Your Email",
              icon: Icons.email,
              onChanged: (value) {
                setState(() {
                  _email = value;
                });
              },
            ),
            RoundedPasswordField(
              onChanged: (value) {
                setState(() {
                  _password = value;
                });
              },
            ),
            RoundedButton(
              text: "LOGIN",
              textColor: const Color(0xFFEDE5CC),
              press: () async {
                final apiService = ApiService();
                try {
                  var result = await apiService.loginUser(_email, _password);
                  print(result['detail']);

                  // Check if 'message' is "Login Successful"
                  if (result['message'] == 'Login Successful') {
                    String userId = result['user_id'];
                    String userEmail = result['email'];
                    String userName = result['username'];
                    String accessToken = result['access_token'];
                    AuthService().storeUserData(userId, userEmail, userName, accessToken);
                    // Navigate to HomePage after successful login
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => PageSwitcher(
                          userEmail: userEmail, // Provide the user's email
                          userName: userName,
                          userId: userId,// Provide the user's name
                        ),
                      ),
                    );

                  } else if (result['detail'] == 'No verified account with this email.') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(result['detail'])),
                    );
                  } else if (result['detail'] == 'Invalid password.') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(result['detail'])),
                    );
                  }
                } catch (error) {
                  print(error);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(error.toString())),
                  );
                }
              },
            ),

            SizedBox(
              height: size.height * 0.03,
            ),
            AlreadyHaveAnAccountCheck(
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignupScreen();
                    },
                  ),
                );
              },
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ForgotPasswordScreen(context),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.only(top: 8.0), // Adjust the top margin as needed
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: Colors.blue.shade300,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

