import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme.light(
    primary: Color.fromARGB(255, 231, 37, 128),
    secondary: Color(0xFFFF9A8B),
    tertiary: Color.fromARGB(255, 66, 66, 66) ,
    onPrimary: Colors.black,
    onSecondary: Color.fromRGBO(255, 255, 255, 1),
    onTertiaryContainer: Color.fromARGB(255, 173, 170, 170)
  ),
  scaffoldBackgroundColor: Colors.grey[1000],
  actionIconTheme: const ActionIconThemeData(),
  textTheme: GoogleFonts.workSansTextTheme(Typography.blackCupertino),
);

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme.dark(
    primary: Color.fromARGB(255, 231, 37, 128),
    secondary: Color(0xFFFF9A8B),
    tertiary: Colors.white,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
  ),
  scaffoldBackgroundColor: Colors.grey[1000],
  textTheme: GoogleFonts.workSansTextTheme(Typography.whiteCupertino),
);
