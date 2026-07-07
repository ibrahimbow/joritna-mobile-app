abstract final class AuthValidators {
  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required.';
    }

    return null;
  }

  static String? email(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'Email is required.';
    }

    if (!email.contains('@') || !email.contains('.')) {
      return 'Enter a valid email address.';
    }

    return null;
  }

  static String? phone(String? value) {
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

  static String? password({required String? value, required bool isLogin}) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }

    if (!isLogin && value.length < 8) {
      return 'Password must be at least 8 characters.';
    }

    return null;
  }

  static String? confirmPassword({
    required String? value,
    required String password,
  }) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password.';
    }

    if (value != password) {
      return 'Passwords do not match.';
    }

    return null;
  }
}
