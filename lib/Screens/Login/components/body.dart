
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

import '../../../views/screens/notification_provider.dart';
import '../../../views/screens/notification_service.dart';
import '../../../views/screens/page_switcher.dart';
import 'package:provider/provider.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}


class _BodyState extends State<Body> {
  String _email = "";
  String _password = "";

  Future<void> _fetchAndSetUnreadNotificationCount(String userId) async {
    try {
      final notificationService = NotificationService('http://192.168.0.100:8000');
      final count = await notificationService.getUnreadNotificationCount(userId);
      Provider.of<NotificationProvider>(context, listen: false).setUnreadCount(count);
    } catch (error) {
      print('Error fetching notification count: $error');
    }
  }

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
                fontFamily: 'serif',
                color: Colors.white,
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
              textColor: Colors.white,
              press: () async {
                final apiService = ApiService();
                try {
                  var result = await apiService.loginUser(_email, _password);

                  // Check if 'message' is "Login Successful"
                  if (result.containsKey('message') && result['message'] == 'Login Successful') {
                    String userId = result['user_id'] ?? ''; // Provide a default value
                    String userEmail = result['email'] ?? ''; // Provide a default value
                    String userName = result['username'] ?? ''; // Provide a default value
                    String accessToken = result['access_token'] ?? ''; // Provide a default value
                    String image = result['imageUrl'] ?? ''; // Provide a default value
                    AuthService().storeUserData(userId, userEmail, userName, accessToken, image);

                    await _fetchAndSetUnreadNotificationCount(userId);


                    // Navigate to HomePage after successful login
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => PageSwitcher(
                          userEmail: userEmail,
                          userName: userName,
                          userId: userId,
                        ),
                      ),
                    );
                  } else if (result.containsKey('detail')) {
                    // Show snackbar with detail message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(result['detail']!)),
                    );
                  } else {
                    // Handle unexpected result
                    print('Unexpected result: $result');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('An unexpected error occurred.')),
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
                margin: EdgeInsets.only(top: 12.0), // Adjust the top margin as needed
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: Colors.blue.shade200,
                    fontSize: 15,
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

