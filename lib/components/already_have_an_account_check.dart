import 'package:flutter/material.dart';
import 'package:whip_up/constants.dart';

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  final VoidCallback press;
  const AlreadyHaveAnAccountCheck({
    super.key,  this.login = true, required this.press,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
         login ? "Dont Have an Account? " : "Already have an Account? ",
          style: TextStyle(
            fontSize: 15,
            color: Colors.yellow.shade50,
          ),
        ),
        GestureDetector(
          onTap: press,
          child: Text(
            login ? "Sign Up" :  "Sign in",
            style: TextStyle(
              fontSize: 15,
              color: Colors.yellow.shade50,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}