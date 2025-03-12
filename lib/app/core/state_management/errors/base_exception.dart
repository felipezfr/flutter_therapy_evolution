abstract class BaseException implements Exception {
  const BaseException({
    required this.message,
    this.data,
    this.errorCode,
    this.stackTrace,
  });

  final dynamic data;
  final String message;
  final String? errorCode;
  final dynamic stackTrace;
}
