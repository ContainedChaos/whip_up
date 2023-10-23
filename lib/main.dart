import 'package:flutter/material.dart';
import 'package:whip_up/Screens/AddRecipe/add_recipe_screen.dart';
// import 'package:whip_up/Screens/GetStarted/presentation/get_started_screen.dart';
import 'package:whip_up/Screens/Home/presentation/home_screen.dart';
import 'package:whip_up/Screens/Welcome/welcome_screen.dart';
// import 'package:whip_up/Screens/Welcome/welcome_screen.dart';
import 'package:whip_up/constants.dart';
import 'package:whip_up/core/route/app_route_name.dart';
import 'package:whip_up/views/screens/auth/welcome_page.dart';
import 'package:whip_up/views/screens/home_page.dart';
import 'package:whip_up/views/screens/page_switcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Recipe App',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: WelcomePage(),
      // routes: {
      //   AppRouteName.home: (context) => HomeScreen(),
      //   // Add other routes as needed
      // },
    );
  }
}
