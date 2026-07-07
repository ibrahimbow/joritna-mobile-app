import 'package:flutter/material.dart';

import '../../../../core/user/user_role.dart';
import '../styles/auth_styles.dart';
import '../validators/auth_validators.dart';
import 'password_field.dart';
import 'register_role_selector.dart';

class RegisterFields extends StatelessWidget {
  const RegisterFields({
    required this.usernameController,
    required this.emailController,
    required this.displayNameController,
    required this.phoneNumberController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.selectedRole,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.isLoading,
    required this.fieldErrors,
    required this.onRoleChanged,
    required this.onClearFieldError,
    required this.onTogglePasswordVisibility,
    required this.onToggleConfirmPasswordVisibility,
    required this.onSubmit,
    super.key,
  });

  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController displayNameController;
  final TextEditingController phoneNumberController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  final UserRole selectedRole;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final bool isLoading;
  final Map<String, String> fieldErrors;

  final ValueChanged<UserRole> onRoleChanged;
  final ValueChanged<String> onClearFieldError;
  final VoidCallback onTogglePasswordVisibility;
  final VoidCallback onToggleConfirmPasswordVisibility;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: displayNameController,
          textInputAction: TextInputAction.next,
          decoration: AuthStyles.inputDecoration(
            label: 'Full name',
            icon: Icons.badge_outlined,
          ),
          validator: AuthValidators.required,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: usernameController,
          textInputAction: TextInputAction.next,
          decoration: AuthStyles.inputDecoration(
            label: 'Username',
            icon: Icons.person_outline_rounded,
          ),
          validator: (value) {
            return fieldErrors['username'] ?? AuthValidators.required(value);
          },
          onChanged: (_) => onClearFieldError('username'),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          decoration: AuthStyles.inputDecoration(
            label: 'Email',
            icon: Icons.email_outlined,
          ),
          validator: (value) {
            return fieldErrors['email'] ?? AuthValidators.email(value);
          },
          onChanged: (_) => onClearFieldError('email'),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: phoneNumberController,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          decoration: AuthStyles.inputDecoration(
            label: 'Phone number',
            icon: Icons.phone_outlined,
          ),
          validator: (value) {
            return fieldErrors['phoneNumber'] ?? AuthValidators.phone(value);
          },
          onChanged: (_) => onClearFieldError('phoneNumber'),
        ),
        const SizedBox(height: 12),
        RegisterRoleSelector(
          selectedRole: selectedRole,
          onChanged: onRoleChanged,
        ),
        const SizedBox(height: 12),
        PasswordField(
          controller: passwordController,
          label: 'Password',
          icon: Icons.lock_outline_rounded,
          obscureText: obscurePassword,
          textInputAction: TextInputAction.next,
          onToggleVisibility: onTogglePasswordVisibility,
          validator: (value) {
            return AuthValidators.password(value: value, isLogin: false);
          },
        ),
        const SizedBox(height: 12),
        PasswordField(
          controller: confirmPasswordController,
          label: 'Confirm password',
          icon: Icons.lock_reset_rounded,
          obscureText: obscureConfirmPassword,
          textInputAction: TextInputAction.done,
          onToggleVisibility: onToggleConfirmPasswordVisibility,
          onFieldSubmitted: (_) {
            if (!isLoading) {
              onSubmit();
            }
          },
          validator: (value) {
            return AuthValidators.confirmPassword(
              value: value,
              password: passwordController.text,
            );
          },
        ),
      ],
    );
  }
}
