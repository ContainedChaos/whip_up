import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key? key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // Background Image with Opacity
          Opacity(
            opacity: 0.75, // Adjust the opacity value as needed
            child: Image.asset(
              "assets/images/signup_bg.jpg", // Replace with your image path
              width: size.width,
              height: size.height,
              fit: BoxFit.cover,
            ),
          ),
          // Gradient Decoration
          Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black45.withOpacity(0.6), // Top color with opacity
                  // Colors.transparent, // Middle color (transparent)
                  Colors.black45.withOpacity(0.6), // Bottom color with opacity
                ], // Define stops for each color
              ),
            ),

          ),
          child,
        ],
      ),
    );
  }
}
