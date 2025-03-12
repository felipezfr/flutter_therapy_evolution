import 'dart:developer' as developer;

class Log {
  static void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? label,
  }) {
    // Log padrão
    developer.log(
      message,
      error: error,
      stackTrace: stackTrace,
      name: label ?? 'ERROR',
    );
  }
}
