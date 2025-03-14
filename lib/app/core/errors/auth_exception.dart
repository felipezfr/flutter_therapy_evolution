import 'base_exception.dart';

class AuthException extends BaseException {
  const AuthException({
    required super.message,
  });

  @override
  String toString() => message;
}
