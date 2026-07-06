import 'failure.dart';

final class ApiFailure extends Failure {
  const ApiFailure({
    required super.message,
    super.code,
    super.statusCode,
    super.validationErrors,
  });

  bool get hasValidationErrors => validationErrors.isNotEmpty;

  bool get isUnauthorized => statusCode == 401;

  bool get isForbidden => statusCode == 403;

  bool get isNotFound => statusCode == 404;

  bool get isServerError => statusCode != null && statusCode! == 500;
}
