import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../tenant/building/data/building_providers.dart';
import '../data/auth_providers.dart';
import '../data/models/requests/login_request.dart';
import '../data/models/requests/register_request.dart';

import '../../../core/errors/api_failure.dart';
import '../../../core/user/current_user_provider.dart';
import '../../../core/user/user_role.dart';
import '../../../core/errors/failure_mapper.dart';

enum AuthMode { login, register }

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({required this.initialMode, super.key});

  final AuthMode initialMode;

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();

  final _usernameOrEmailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Map<String, String> _fieldErrors = const {};

  late AuthMode _mode;

  UserRole _selectedRegisterRole = UserRole.tenant;

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _errorMessage;

  static const Color _officialBlue = Color(0xFF2563EB);

  bool get _isLogin => _mode == AuthMode.login;

  @override
  void initState() {
    super.initState();
    _mode = widget.initialMode;
  }

  @override
  void dispose() {
    _usernameOrEmailController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _displayNameController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      if (_isLogin) {
        await _login();
      } else {
        await _register();
      }
    } catch (error, stackTrace) {
      debugPrint('AUTH FAILED: $error');
      debugPrint('AUTH STACKTRACE: $stackTrace');

      if (!mounted) {
        return;
      }

      final failure = FailureMapper.map(
        error,
        fallbackMessage: _isLogin
            ? 'Login failed. Please check your details.'
            : 'Registration failed. Please check your details.',
      );

      setState(() {
        _errorMessage = failure.message;
        _fieldErrors = failure.validationErrors;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _login() async {
    await ref
        .read(authRepositoryProvider)
        .login(
          LoginRequest(
            usernameOrEmail: _usernameOrEmailController.text.trim(),
            password: _passwordController.text,
          ),
        );

    ref.invalidate(currentUserProvider);

    final currentUser = await ref.read(currentUserProvider.future);

    if (!mounted) {
      return;
    }

    switch (currentUser.role) {
      case UserRole.manager:
        context.go(AppRoutes.managerDashboard);
        return;

      case UserRole.tenant:
        final hasBuilding = await ref
            .read(buildingRepositoryProvider)
            .hasMyBuilding();

        if (!mounted) {
          return;
        }

        context.go(
          hasBuilding ? AppRoutes.tenantDashboard : AppRoutes.tenantBuilding,
        );
        return;

      default:
        throw const ApiFailure(
          message: 'This account type is not supported in the mobile app.',
        );
    }
  }

  Future<void> _register() async {
    await ref
        .read(authRepositoryProvider)
        .register(
          RegisterRequest(
            username: _usernameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
            displayName: _displayNameController.text.trim(),
            phoneNumber: _phoneNumberController.text.trim(),
            role: _selectedRegisterRole,
          ),
        );

    if (!mounted) {
      return;
    }

    setState(() {
      _mode = AuthMode.login;
      _errorMessage = null;
      _usernameOrEmailController.text = _emailController.text.trim();
      _passwordController.clear();
      _confirmPasswordController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Account created successfully. Please login.'),
      ),
    );
  }

  void _switchMode() {
    setState(() {
      _mode = _isLogin ? AuthMode.register : AuthMode.login;
      _selectedRegisterRole = UserRole.tenant;
      _errorMessage = null;
      _fieldErrors = const {};
      _formKey.currentState?.reset();
      _passwordController.clear();
      _confirmPasswordController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Container(
                  key: ValueKey(_mode),
                  padding: const EdgeInsets.all(26),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 28,
                        offset: const Offset(0, 14),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _Header(isLogin: _isLogin),
                        const SizedBox(height: 20),

                        if (_isLogin)
                          TextFormField(
                            controller: _usernameOrEmailController,
                            textInputAction: TextInputAction.next,
                            decoration: _inputDecoration(
                              label: 'Username or email',
                              icon: Icons.person_outline_rounded,
                            ),
                            validator: _requiredValidator,
                          )
                        else ...[
                          TextFormField(
                            controller: _displayNameController,
                            textInputAction: TextInputAction.next,
                            decoration: _inputDecoration(
                              label: 'Full name',
                              icon: Icons.badge_outlined,
                            ),
                            validator: _requiredValidator,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _usernameController,
                            textInputAction: TextInputAction.next,
                            decoration: _inputDecoration(
                              label: 'Username',
                              icon: Icons.person_outline_rounded,
                            ),
                            validator: (value) {
                              return _fieldError('username') ??
                                  _requiredValidator(value);
                            },
                            onChanged: (_) => _clearFieldError('username'),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            decoration: _inputDecoration(
                              label: 'Email',
                              icon: Icons.email_outlined,
                            ),
                            validator: (value) {
                              return _fieldError('email') ??
                                  _emailValidator(value);
                            },
                            onChanged: (_) => _clearFieldError('email'),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _phoneNumberController,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            onChanged: (_) => _clearFieldError('phoneNumber'),
                            decoration: _inputDecoration(
                              label: 'Phone number',
                              icon: Icons.phone_outlined,
                            ),
                            validator: (value) {
                              return _fieldError('phoneNumber') ??
                                  _phoneValidator(value);
                            },
                          ),
                          const SizedBox(height: 12),
                          _RegisterRoleSelector(
                            selectedRole: _selectedRegisterRole,
                            onChanged: (role) {
                              setState(() {
                                _selectedRegisterRole = role;
                              });
                            },
                          ),
                        ],

                        const SizedBox(height: 12),

                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          textInputAction: _isLogin
                              ? TextInputAction.done
                              : TextInputAction.next,
                          onFieldSubmitted: (_) {
                            if (_isLogin && !_isLoading) {
                              _submit();
                            }
                          },
                          decoration: _inputDecoration(
                            label: 'Password',
                            icon: Icons.lock_outline_rounded,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                            ),
                          ),
                          validator: _passwordValidator,
                        ),

                        if (!_isLogin) ...[
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: _obscureConfirmPassword,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) {
                              if (!_isLoading) {
                                _submit();
                              }
                            },
                            decoration: _inputDecoration(
                              label: 'Confirm password',
                              icon: Icons.lock_reset_rounded,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword =
                                        !_obscureConfirmPassword;
                                  });
                                },
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                ),
                              ),
                            ),
                            validator: _confirmPasswordValidator,
                          ),
                        ],

                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 220),
                          child: _errorMessage == null
                              ? const SizedBox.shrink()
                              : Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.error
                                          .withValues(alpha: 0.08),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Text(
                                      _errorMessage!,
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.error,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                        ),

                        const SizedBox(height: 18),

                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: _officialBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: _isLoading ? null : _submit,
                            child: _isLoading
                                ? const SizedBox(
                                    width: 22,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.4,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    _isLogin ? 'Login' : 'Create account',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _isLogin
                                  ? 'New to Joritna?'
                                  : 'Already have an account?',
                              style: const TextStyle(color: Color(0xFF64748B)),
                            ),
                            TextButton(
                              onPressed: _isLoading ? null : _switchMode,
                              child: Text(
                                _isLogin ? 'Create account' : 'Login',
                                style: const TextStyle(
                                  color: _officialBlue,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
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
      fillColor: const Color(0xFFF8FAFC),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _officialBlue, width: 1.5),
      ),
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required.';
    }

    return null;
  }

  String? _emailValidator(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'Email is required.';
    }

    if (!email.contains('@') || !email.contains('.')) {
      return 'Enter a valid email address.';
    }

    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }

    if (!_isLogin && value.length < 8) {
      return 'Password must be at least 8 characters.';
    }

    return null;
  }

  String? _phoneValidator(String? value) {
    final phone = value?.trim() ?? '';

    if (phone.isEmpty) {
      return 'Phone number is required.';
    }

    final normalizedPhone = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    final phonePattern = RegExp(r'^\+?[0-9]{7,15}$');

    if (!phonePattern.hasMatch(normalizedPhone)) {
      return 'Please enter a valid phone number.';
    }

    return null;
  }

  String? _confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password.';
    }

    if (value != _passwordController.text) {
      return 'Passwords do not match.';
    }

    return null;
  }

  void _clearFieldError(String fieldName) {
    if (!_fieldErrors.containsKey(fieldName) && _errorMessage == null) {
      return;
    }

    setState(() {
      final updatedErrors = Map<String, String>.from(_fieldErrors)
        ..remove(fieldName);

      _fieldErrors = updatedErrors;
      _errorMessage = null;
    });
  }

  String? _fieldError(String fieldName) {
    return _fieldErrors[fieldName];
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.isLogin});

  final bool isLogin;

  static const Color _officialBlue = Color(0xFF2563EB);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            color: _officialBlue.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(22),
          ),
          child: const Icon(
            Icons.apartment_rounded,
            color: _officialBlue,
            size: 36,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          isLogin ? 'Welcome back' : 'Create your account',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          isLogin
              ? 'Login to continue to Joritna'
              : 'Choose your role and join Joritna',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF64748B)),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _RegisterRoleSelector extends StatelessWidget {
  const _RegisterRoleSelector({
    required this.selectedRole,
    required this.onChanged,
  });

  final UserRole selectedRole;
  final ValueChanged<UserRole> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _RoleOptionCard(
            title: 'Tenant',
            subtitle: 'Join a building',
            icon: Icons.home_outlined,
            isSelected: selectedRole == UserRole.tenant,
            onTap: () => onChanged(UserRole.tenant),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _RoleOptionCard(
            title: 'Manager',
            subtitle: 'Manage building',
            icon: Icons.apartment_rounded,
            isSelected: selectedRole == UserRole.manager,
            onTap: () => onChanged(UserRole.manager),
          ),
        ),
      ],
    );
  }
}

class _RoleOptionCard extends StatelessWidget {
  const _RoleOptionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  static const Color _officialBlue = Color(0xFF2563EB);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? _officialBlue.withValues(alpha: 0.08)
              : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? _officialBlue : const Color(0xFFE2E8F0),
            width: isSelected ? 1.6 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? _officialBlue : const Color(0xFF64748B),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: isSelected ? _officialBlue : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
            ),
          ],
        ),
      ),
    );
  }
}
