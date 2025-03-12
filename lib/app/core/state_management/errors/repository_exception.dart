import 'base_exception.dart';

class RepositoryException extends BaseException {
  RepositoryException({
    required super.message,
    super.data,
    super.stackTrace,
    super.errorCode,
  });
}
