import 'package:flutter/material.dart';

import '../../../../features/auth/presentation/styles/auth_styles.dart';
import '../../../../features/auth/presentation/validators/auth_validators.dart';
import 'password_field.dart';

class LoginFields extends StatelessWidget {
  const LoginFields({
    required this.usernameOrEmailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.isLoading,
    required this.onTogglePasswordVisibility,
    required this.onSubmit,
    super.key,
  });

  final TextEditingController usernameOrEmailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final bool isLoading;
  final VoidCallback onTogglePasswordVisibility;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: usernameOrEmailController,
          textInputAction: TextInputAction.next,
          decoration: AuthStyles.inputDecoration(
            label: 'Username or email',
            icon: Icons.person_outline_rounded,
          ),
          validator: AuthValidators.required,
        ),
        const SizedBox(height: 12),
        PasswordField(
          controller: passwordController,
          label: 'Password',
          icon: Icons.lock_outline_rounded,
          obscureText: obscurePassword,
          textInputAction: TextInputAction.done,
          onToggleVisibility: onTogglePasswordVisibility,
          onFieldSubmitted: (_) {
            if (!isLoading) {
              onSubmit();
            }
          },
          validator: (value) {
            return AuthValidators.password(value: value, isLogin: true);
          },
        ),
      ],
    );
  }
}
