import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0xFF121312),
    primaryColor: const Color(0xFFFFBB00),
    fontFamily: "Poppins", // لو ضفت الخط
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF121312),
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1E1E1E),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
  );
}