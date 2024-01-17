import 'package:flutter/material.dart';
import 'package:whip_up/constants.dart';
import 'package:provider/provider.dart';

import 'package:whip_up/views/screens/auth/welcome_page.dart';
import 'package:whip_up/views/screens/notification_provider.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
// Wrap your MaterialApp with ChangeNotifierProvider
    return ChangeNotifierProvider(
// Initialize the NotificationProvider here
      create: (context) => NotificationProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My Recipe App',
        theme: ThemeData(
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: WelcomePage(),
      ),
    );
  }
}
