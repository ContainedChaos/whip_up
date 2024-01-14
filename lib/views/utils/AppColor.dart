import 'package:flutter/material.dart';

class AppColor {
  static Color primary = Color(0xFF094542);
  static Color primarySoft = Color(0xFF0B5551);
  static Color primaryExtraSoft = Color(0xFFEEF4F4);
  static Color secondary = Color(0xFFEDE5CC);
  static Color secondarySoft = Color(0xFFD9D4C9);
  static Color secondaryDark = Color(0xFFA79981);
  static Color whiteSoft = Color(0xFFF8F8F8);
  static LinearGradient bottomShadow = LinearGradient(colors: [Color(0xFF107873).withOpacity(0.2), Color(0xFF107873).withOpacity(0)], begin: Alignment.bottomCenter, end: Alignment.topCenter);
  static LinearGradient linearBlackBottom = LinearGradient(colors: [Colors.black.withOpacity(0.3), Colors.black.withOpacity(0)], begin: Alignment.bottomCenter, end: Alignment.topCenter);
  static LinearGradient linearBlackTop = LinearGradient(colors: [Colors.black.withOpacity(0.5), Colors.transparent], begin: Alignment.topCenter, end: Alignment.bottomCenter);
}
