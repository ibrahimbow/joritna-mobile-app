abstract final class ErrorMessages {
  const ErrorMessages._();

  static const String conflict = 'This resource already exists.';

  static const String tooManyRequests =
      'Too many requests. Please try again later.';

  static const String unexpected = 'Something went wrong. Please try again.';
  static const String network =
      'No internet connection. Please check your connection and try again.';
  static const String timeout = 'The request took too long. Please try again.';
  static const String unauthorized =
      'Your session has expired. Please login again.';
  static const String forbidden =
      'You do not have permission to perform this action.';
  static const String notFound =
      'The requested information could not be found.';
  static const String server =
      'The server is currently unavailable. Please try again later.';
  static const String validation =
      'Please check the entered information and try again.';
}
