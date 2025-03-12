import 'package:result_dart/result_dart.dart';

import '../state_management/errors/base_exception.dart';

typedef Output<T extends Object> = AsyncResult<T, BaseException>;
