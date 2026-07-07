import 'package:flutter/material.dart';

class ManagerBuildingTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final String? Function(String?) validator;

  const ManagerBuildingTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.validator,
    this.keyboardType,
  });

  static const Color primaryBlue = Color(0xFF0057C8);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: primaryBlue),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: primaryBlue, width: 1.4),
        ),
      ),
    );
  }
}
