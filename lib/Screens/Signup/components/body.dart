// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whip_up/Screens/Login/login_screen.dart';
import 'package:whip_up/Screens/Signup/components/background.dart';
import 'package:whip_up/Screens/Signup/components/or_divider.dart';
import 'package:whip_up/Screens/Signup/components/social_icon.dart';
import 'package:whip_up/components/already_have_an_account_check.dart';
import 'package:whip_up/components/rounded_button.dart';
import 'package:whip_up/components/rounded_input_field.dart';
import 'package:whip_up/components/rounded_password_field.dart';
// import 'package:whip_up/constants.dart';
import 'package:whip_up/Screens/Signup/api_service.dart';
import 'package:whip_up/Screens/Welcome/welcome_screen.dart';
import 'package:whip_up/Screens/verify_screen.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String _email = "";
  String _password = "";
  String _username = "";
  List<String> errorMessages = [];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "SIGNUP",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          SvgPicture.asset(
            "assets/icons/signup.svg",
            height: size.height * 0.35,
          ),
          // RoundedInputField(
          //   hintText: "Your Email",
          //   onChanged: (value) {
          //     setState(() {
          //       _email = value;
          //     });
          //   },
          // ),
          RoundedInputField(
            hintText: "Username",
            icon: Icons.person,
            onChanged: (value) {
              // Set the username value in a variable
              setState(() {
                _username = value;
              });
            },
          ),
          RoundedInputField(
            hintText: "Your Email",
            icon: Icons.email, // This is the missing argument you need to add.
            onChanged: (value) {
              setState(() {
                _email = value;
              });
            },
          ),
          // RoundedPasswordField(
          //   onChanged: (value) {
          //     setState(() {
          //       _password = value;
          //     });
          //   },
          // ),
          RoundedPasswordField(
            onChanged: (value) {
              setState(() {
                _password = value;
              });
            },
          ),
          RoundedButton(
            text: "SIGNUP",
            press: () async {
              errorMessages.clear();
              // Validate email using a regular expression for a valid email format.
              RegExp emailRegExp = RegExp(
                r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
              );

              if (_email.isEmpty) {
                errorMessages.add('Email is required.');
              } else if (!emailRegExp.hasMatch(_email)) {
                errorMessages.add('Invalid email format.');
              }

              // Validate password for length, capital letter, and digit.
              RegExp passwordRegExp = RegExp(
                r"^(?=.*[A-Z])(?=.*[0-9])[a-zA-Z0-9]{6,}$",
              );

              if (_password.isEmpty) {
                errorMessages.add('Password is required.');
              } else if (!passwordRegExp.hasMatch(_password)) {
                errorMessages.add(
                    'Password must be at least 6 characters long and contain at least 1 capital letter and 1 digit.');
              }

              if (errorMessages.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(errorMessages.join('\n')),
                    backgroundColor: Colors.red,
                  ),
                );
                return; // Exit the function early.
              }

              // If validations pass, proceed to call the API.
              final apiService = ApiService();
              final response =
                  await apiService.signup(_username, _email, _password);

              if (response['message'] == 'User Created') {
                // Handle successful signup, e.g., navigate to another page or show a success message
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        VerifyScreen(userId: response["userId"]),
                  ),
                );
              } else if (response['message'] == 'Customer Exists') {
                // Add this block
                // Handle email already in use
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('User already exists'),
                    backgroundColor: Colors.red,
                  ),
                );
              } else {
                // Handle errors, e.g., show an error message to the user
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text(response['message'] ?? 'Unknown error occurred'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
          //

          SizedBox(height: size.height * 0.03),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return LoginScreen();
                  },
                ),
              );
            },
          ),
          orDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SocialIcon(
                iconSrc: "assets/icons/facebook.svg",
                press: () {},
              ),
              SocialIcon(
                iconSrc: "assets/icons/google-plus.svg",
                press: () {},
              ),
            ],
          )
        ],
      ),
    );
  }
}
