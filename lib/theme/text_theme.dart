

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class AppTextTheme {

  static final TextStyle display = GoogleFonts.michroma(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static final TextStyle headline = GoogleFonts.michroma(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static final TextStyle title = GoogleFonts.electrolize(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );
  
  static final TextStyle body = GoogleFonts.montserrat(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colors.white,
  );
  
  


  static final TextTheme theme = TextTheme(
    displayLarge: display.copyWith(fontSize: 56),
    displayMedium: display.copyWith(fontSize: 48),
    displaySmall: display.copyWith(fontSize: 40),
    
    headlineLarge: headline.copyWith(fontSize: 36),
    headlineMedium: headline.copyWith(fontSize: 32),
    headlineSmall: headline.copyWith(fontSize: 28),

    titleLarge: title.copyWith(fontSize: 26),
    titleMedium: title.copyWith(fontSize: 24),
    titleSmall: title.copyWith(fontSize: 22),

    bodyLarge: body.copyWith(fontSize: 18),
    bodyMedium: body.copyWith(fontSize: 16),
    bodySmall: body.copyWith(fontSize: 14),
  );
}



