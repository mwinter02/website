import 'package:flutter/material.dart';
import 'package:website/theme/text_theme.dart';

// App bar uses a custom gradient painted via FlexibleSpaceBar, so we strip
// the background colour here and let site_widgets.dart own the painting.
final AppBarTheme appBarTheme = AppBarTheme(
  backgroundColor: Colors.transparent,
  elevation: 0,
  scrolledUnderElevation: 0,
);

ThemeData appTheme = ThemeData(
  primarySwatch: Colors.deepPurple,
  appBarTheme: appBarTheme,
  textTheme: AppTextTheme.theme,
  // Charcoal: very slightly blue-tinted near-black — pairs with deep purple
  // without the harshness of pure white.
  scaffoldBackgroundColor: const Color(0xFF0D0D14),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

class ThemeColors {
  static const Color primary = Colors.deepPurple;
  static const Color secondary = Colors.deepPurpleAccent;

  /// Page background — cool charcoal.
  static const Color background = Color(0xFF0D0D14);

  /// App bar gradient stops.
  static const Color appBarStart = Color(0xFF0D0D14); // charcoal
  static const Color appBarEnd = Color(0xFF1A0A3C); // deep indigo

  /// Thin accent rule under the app bar.
  static const Color appBarAccent = Color(0xFF7C4DFF); // deepPurpleAccent[200]

  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB0B0C8); // muted lavender-grey
}