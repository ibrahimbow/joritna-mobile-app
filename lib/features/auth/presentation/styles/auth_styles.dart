import 'package:flutter/material.dart';

abstract final class AuthStyles {
  static const Color officialBlue = Color(0xFF2563EB);
  static const Color background = Color(0xFFF4F7FB);
  static const Color fieldBackground = Color(0xFFF8FAFC);
  static const Color border = Color(0xFFE2E8F0);
  static const Color textDark = Color(0xFF0F172A);
  static const Color textMuted = Color(0xFF64748B);

  static InputDecoration inputDecoration({
    required String label,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 20),
      suffixIcon: suffixIcon,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      filled: true,
      fillColor: fieldBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: officialBlue, width: 1.5),
      ),
    );
  }
}
