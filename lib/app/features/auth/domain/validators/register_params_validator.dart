import 'package:flutter_therapy_evolution/app/core/extensions/lucid_validator_extension.dart';
import 'package:lucid_validation/lucid_validation.dart';

import '../../presentation/models/register_params.dart';

class RegisterParamsValidator extends LucidValidator<RegisterParams> {
  RegisterParamsValidator() {
    ruleFor((user) => user.name, key: 'name', label: 'nome')
        .notEmpty()
        .minLength(3);

    ruleFor((user) => user.email, key: 'email', label: 'e-mail')
        .notEmpty()
        .validEmail();

    ruleFor((user) => user.password, key: 'password', label: 'senha')
        .customValidPassword();

    ruleFor((user) => user.confirmPassword,
            key: 'confirmPassword', label: 'confirmar senha')
        .customValidPassword()
        .equalTo((user) => user.password, message: 'senhas não conferem');
  }
}
