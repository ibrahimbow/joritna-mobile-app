import 'package:dio/dio.dart';

class Failure {
  const Failure({
    required this.message,
    this.code,
    this.statusCode,
    this.validationErrors = const {},
  });

  final String message;
  final String? code;
  final int? statusCode;
  final Map<String, String> validationErrors;

  factory Failure.fromException(
    Object error, {
    required String fallbackMessage,
  }) {
    if (error is DioException) {
      final data = error.response?.data;

      if (data is Map<String, dynamic>) {
        final validationErrors = _readValidationErrors(data);

        return Failure(
          message: _readMessage(data) ?? fallbackMessage,
          code: data['error'] as String?,
          statusCode: data['status'] as int? ?? error.response?.statusCode,
          validationErrors: validationErrors,
        );
      }

      if (data is String && data.trim().isNotEmpty) {
        return Failure(message: data, statusCode: error.response?.statusCode);
      }

      return Failure(
        message: fallbackMessage,
        statusCode: error.response?.statusCode,
      );
    }

    return Failure(message: fallbackMessage);
  }

  static String? _readMessage(Map<String, dynamic> data) {
    final message = data['message'];

    if (message is String && message.trim().isNotEmpty) {
      return message;
    }

    return null;
  }

  static Map<String, String> _readValidationErrors(Map<String, dynamic> data) {
    final rawErrors = data['validationErrors'];

    if (rawErrors is! Map) {
      return const {};
    }

    return rawErrors.map(
      (key, value) => MapEntry(key.toString(), value.toString()),
    );
  }
}
