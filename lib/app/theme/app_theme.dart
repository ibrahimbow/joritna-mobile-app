import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF1E3A8A),
      ),
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
    );
  }
}