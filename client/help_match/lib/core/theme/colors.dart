import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.light(
    primary: Colors.tealAccent[700] ?? Colors.tealAccent,
    secondary: Colors.black,
    tertiary: const Color.fromARGB(255, 114, 114, 114),
    onPrimary: Colors.black,
    onSecondary: Colors.white,
  ),
  scaffoldBackgroundColor: Colors.white,
  actionIconTheme: const ActionIconThemeData(),
  textTheme: GoogleFonts.workSansTextTheme(Typography.blackCupertino),
);

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.dark(
    primary: Colors.tealAccent[700] ?? Colors.tealAccent,
    secondary: Colors.grey[850] ?? Colors.grey,
    tertiary: Colors.grey[900],
    onPrimary: Colors.white,
    onSecondary: Colors.black,
  ),
  scaffoldBackgroundColor: Colors.grey[1000],
  textTheme: GoogleFonts.workSansTextTheme(Typography.whiteCupertino),
);
