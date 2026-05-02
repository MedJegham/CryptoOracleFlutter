class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  AppException({
    required this.message,
    this.code,
    this.details,
  });

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  NetworkException({
    required super.message,
    super.code,
    super.details,
  });
}

class ServerException extends AppException {
  ServerException({
    required super.message,
    super.code,
    super.details,
  });
}

class CacheException extends AppException {
  CacheException({
    required super.message,
    super.code,
    super.details,
  });
}

class AuthException extends AppException {
  AuthException({
    required super.message,
    super.code,
    super.details,
  });
}

class ValidationException extends AppException {
  ValidationException({
    required super.message,
    super.code,
    super.details,
  });
}

class TimeoutException extends AppException {
  TimeoutException({
    required super.message,
    super.code,
    super.details,
  });
}

class UnauthorizedException extends AppException {
  UnauthorizedException({
    String message = 'Session expired. Please login again.',
    super.code,
    super.details,
  }) : super(message: message);
}
