

import 'package:flutter/material.dart';
import 'package:website/theme/text_theme.dart';

final AppBarTheme appBarTheme = AppBarTheme(
  backgroundColor: Colors.deepPurple,
  elevation: 0,
);

ThemeData appTheme = ThemeData(
  primarySwatch: Colors.blue,
  appBarTheme: appBarTheme,
  textTheme: AppTextTheme.theme,
  scaffoldBackgroundColor: Colors.white,
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

class ThemeColors {
  static const Color primary = Colors.deepPurple;
  static const Color secondary = Colors.deepPurpleAccent;
  static const Color background = Colors.white;
  static const Color textPrimary = Colors.black87;
  static const Color textSecondary = Colors.black54;
}