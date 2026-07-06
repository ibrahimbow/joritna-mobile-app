import 'package:dio/dio.dart';

import 'api_failure.dart';
import 'error_messages.dart';
import 'exception.dart';
import 'failure.dart';

abstract final class FailureMapper {
  const FailureMapper._();

  static ApiFailure map(
    Object error, {
    String fallbackMessage = ErrorMessages.unexpected,
  }) {
    if (error is ApiFailure) {
      return error;
    }

    if (error is Failure) {
      return ApiFailure(
        message: error.message,
        code: error.code,
        statusCode: error.statusCode,
        validationErrors: error.validationErrors,
      );
    }

    if (error is AppException) {
      return ApiFailure(message: error.message, statusCode: error.statusCode);
    }

    if (error is DioException) {
      final failure = Failure.fromException(
        error,
        fallbackMessage: _messageForDioException(error, fallbackMessage),
      );

      return ApiFailure(
        message: failure.message,
        code: failure.code,
        statusCode: failure.statusCode,
        validationErrors: failure.validationErrors,
      );
    }

    return ApiFailure(message: fallbackMessage);
  }

  static String _messageForDioException(
    DioException error,
    String fallbackMessage,
  ) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ErrorMessages.timeout;

      case DioExceptionType.connectionError:
        return ErrorMessages.network;

      case DioExceptionType.badResponse:
        return _messageForStatusCode(error.response?.statusCode);

      case DioExceptionType.cancel:
        return fallbackMessage;

      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return fallbackMessage;
    }
  }

  static String _messageForStatusCode(int? statusCode) {
    if (statusCode == null) {
      return ErrorMessages.unexpected;
    }

    if (statusCode >= 500) {
      return ErrorMessages.server;
    }

    return switch (statusCode) {
      400 => ErrorMessages.validation,
      401 => ErrorMessages.unauthorized,
      403 => ErrorMessages.forbidden,
      404 => ErrorMessages.notFound,
      409 => ErrorMessages.conflict,
      429 => ErrorMessages.tooManyRequests,
      _ => ErrorMessages.unexpected,
    };
  }
}
