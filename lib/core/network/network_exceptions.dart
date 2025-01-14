// network_exceptions.dart

class NetworkException implements Exception {
  final String message;
  final int? statusCode;

  NetworkException({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => message;

  factory NetworkException.fromStatusCode(int statusCode) {
    switch (statusCode) {
      case 401:
        return NetworkException(
          message: 'Unauthorized access. Please login again.',
          statusCode: statusCode,
        );
      case 404:
        return NetworkException(
          message: 'Resource not found',
          statusCode: statusCode,
        );
      case 500:
        return NetworkException(
          message: 'Server error. Please try again later.',
          statusCode: statusCode,
        );
      default:
        return NetworkException(
          message: 'An unexpected error occurred',
          statusCode: statusCode,
        );
    }
  }
}
