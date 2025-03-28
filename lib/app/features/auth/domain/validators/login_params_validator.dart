import 'package:lucid_validation/lucid_validation.dart';

import '../../presentation/models/login_params.dart';

class LoginParamsValidator extends LucidValidator<LoginParams> {
  LoginParamsValidator() {
    ruleFor((user) => user.email, key: 'email', label: 'Email')
        .notEmpty()
        .validEmail();
  }
}
