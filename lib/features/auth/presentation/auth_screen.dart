import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/config/app_config.dart';
import '../../../app/router/app_routes.dart';
import '../../../core/errors/api_failure.dart';
import '../../../core/errors/failure_mapper.dart';
import '../../../core/notifications/providers/notification_initializer_provider.dart';
import '../../../core/storage/token_storage_provider.dart';
import '../../../core/user/current_user_provider.dart';
import '../../../core/user/user_role.dart';
import '../../manager/building/data/manager_building_providers.dart';
import '../../tenant/building/data/building_providers.dart';
import '../data/auth_providers.dart';
import '../data/models/requests/login_request.dart';
import '../data/models/requests/register_request.dart';
import 'auth_mode.dart';
import 'styles/auth_styles.dart';
import 'widgets/auth_card.dart';
import 'widgets/auth_error_banner.dart';
import 'widgets/auth_header.dart';
import 'widgets/auth_mode_switcher.dart';
import 'widgets/auth_submit_button.dart';
import 'widgets/login_fields.dart';
import 'widgets/register_fields.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({required this.initialMode, super.key});

  final AuthMode initialMode;

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  static const Duration _authenticationTimeout = Duration(seconds: 15);

  static const Duration _buildingLookupTimeout = Duration(seconds: 10);

  static const Duration _notificationInitializationTimeout = Duration(
    seconds: 10,
  );

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameOrEmailController =
      TextEditingController();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  late AuthMode _mode;

  Map<String, String> _fieldErrors = const {};

  UserRole _selectedRegisterRole = UserRole.tenant;

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  String? _errorMessage;

  bool get _isLogin => _mode.isLogin;

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
    if (_isLoading) {
      return;
    }

    FocusScope.of(context).unfocus();

    final formState = _formKey.currentState;

    if (formState == null || !formState.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _fieldErrors = const {};
    });

    try {
      if (_isLogin) {
        await _login();
      } else {
        await _register();
      }
    } on TimeoutException catch (error, stackTrace) {
      debugPrint('AUTH TIMEOUT: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage =
            'The server is taking too long to respond. Please try again.';
        _fieldErrors = const {};
      });
    } catch (error, stackTrace) {
      debugPrint('AUTH FAILED: $error');
      debugPrintStack(stackTrace: stackTrace);

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
        )
        .timeout(_authenticationTimeout);

    ref.invalidate(currentUserProvider);

    final currentUser = await ref
        .read(currentUserProvider.future)
        .timeout(_authenticationTimeout);

    if (!mounted) {
      return;
    }

    unawaited(_initializeNotificationsSafely(userId: currentUser.id));

    await _navigateAfterAuthentication(currentUser.role);
  }

  Future<void> _register() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    await ref
        .read(authRepositoryProvider)
        .register(
          RegisterRequest(
            username: _usernameController.text.trim(),
            email: email,
            password: password,
            displayName: _displayNameController.text.trim(),
            phoneNumber: _phoneNumberController.text.trim(),
            role: _selectedRegisterRole,
          ),
        )
        .timeout(_authenticationTimeout);

    await ref
        .read(authRepositoryProvider)
        .login(LoginRequest(usernameOrEmail: email, password: password))
        .timeout(_authenticationTimeout);

    ref.invalidate(currentUserProvider);

    final currentUser = await ref
        .read(currentUserProvider.future)
        .timeout(_authenticationTimeout);

    if (!mounted) {
      return;
    }

    unawaited(_initializeNotificationsSafely(userId: currentUser.id));

    await _navigateAfterAuthentication(currentUser.role);
  }

  Future<void> _initializeNotificationsSafely({required int userId}) async {
    /*
     * Capture provider dependencies before the AuthScreen can be disposed
     * after navigation.
     */
    final tokenStorage = ref.read(tokenStorageProvider);
    final notificationInitializer = ref.read(notificationInitializerProvider);

    try {
      final token = await tokenStorage.getAccessToken();

      if (token == null || token.isEmpty) {
        debugPrint(
          'Notification initialization skipped because no access token exists.',
        );

        return;
      }

      await notificationInitializer
          .initialize(
            userId: userId,
            socketUrl: '${AppConfig.webSocketBaseUrl}/ws/notifications',
            accessToken: token,
          )
          .timeout(_notificationInitializationTimeout);
    } on TimeoutException catch (error, stackTrace) {
      debugPrint('Notification initialization timed out: $error');

      debugPrintStack(stackTrace: stackTrace);
    } catch (error, stackTrace) {
      debugPrint('Notification initialization failed: $error');

      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<void> _navigateAfterAuthentication(UserRole role) async {
    switch (role) {
      case UserRole.manager:
        final hasBuilding = await ref
            .read(managerBuildingRepositoryProvider)
            .hasMyManagedBuilding()
            .timeout(_buildingLookupTimeout);

        if (!mounted) {
          return;
        }

        context.go(
          hasBuilding ? AppRoutes.managerDashboard : AppRoutes.managerBuilding,
        );

        return;

      case UserRole.tenant:
        final hasBuilding = await ref
            .read(buildingRepositoryProvider)
            .hasMyBuilding()
            .timeout(_buildingLookupTimeout);

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

  void _switchMode() {
    if (_isLoading) {
      return;
    }

    setState(() {
      _mode = _mode.toggled;
      _selectedRegisterRole = UserRole.tenant;

      _errorMessage = null;
      _fieldErrors = const {};

      _formKey.currentState?.reset();

      _usernameOrEmailController.clear();
      _usernameController.clear();
      _emailController.clear();
      _displayNameController.clear();
      _phoneNumberController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();

      _obscurePassword = true;
      _obscureConfirmPassword = true;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuthStyles.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: AuthCard(
                modeKey: _mode,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AuthHeader(isLogin: _isLogin),
                      const SizedBox(height: 20),
                      if (_isLogin)
                        LoginFields(
                          usernameOrEmailController: _usernameOrEmailController,
                          passwordController: _passwordController,
                          obscurePassword: _obscurePassword,
                          isLoading: _isLoading,
                          onTogglePasswordVisibility: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          onSubmit: _submit,
                        )
                      else
                        RegisterFields(
                          usernameController: _usernameController,
                          emailController: _emailController,
                          displayNameController: _displayNameController,
                          phoneNumberController: _phoneNumberController,
                          passwordController: _passwordController,
                          confirmPasswordController: _confirmPasswordController,
                          selectedRole: _selectedRegisterRole,
                          obscurePassword: _obscurePassword,
                          obscureConfirmPassword: _obscureConfirmPassword,
                          isLoading: _isLoading,
                          fieldErrors: _fieldErrors,
                          onRoleChanged: (role) {
                            setState(() {
                              _selectedRegisterRole = role;
                            });
                          },
                          onClearFieldError: _clearFieldError,
                          onTogglePasswordVisibility: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          onToggleConfirmPasswordVisibility: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                          onSubmit: _submit,
                        ),
                      AuthErrorBanner(message: _errorMessage),
                      const SizedBox(height: 18),
                      AuthSubmitButton(
                        isLogin: _isLogin,
                        isLoading: _isLoading,
                        onPressed: _submit,
                      ),
                      const SizedBox(height: 16),
                      AuthModeSwitcher(
                        isLogin: _isLogin,
                        isLoading: _isLoading,
                        onPressed: _switchMode,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
