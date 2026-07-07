import 'package:flutter/material.dart';

import '../styles/auth_styles.dart';

class PasswordField extends StatelessWidget {
  const PasswordField({
    required this.controller,
    required this.label,
    required this.icon,
    required this.obscureText,
    required this.onToggleVisibility,
    required this.validator,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscureText;
  final VoidCallback onToggleVisibility;
  final FormFieldValidator<String> validator;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      decoration: AuthStyles.inputDecoration(
        label: label,
        icon: icon,
        suffixIcon: IconButton(
          onPressed: onToggleVisibility,
          icon: Icon(
            obscureText
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
          ),
        ),
      ),
      validator: validator,
    );
  }
}
