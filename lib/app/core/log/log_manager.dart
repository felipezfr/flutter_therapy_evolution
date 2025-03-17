import 'package:logger/logger.dart';

class Log {
  static final logger = Logger();

  static void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? label,
  }) {
    logger.e(message, error: error, stackTrace: stackTrace);
  }

  static void info(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? label,
  }) {
    logger.i(message, error: error, stackTrace: stackTrace);
  }
}
