import 'package:lucid_validation/lucid_validation.dart';

extension CustomValidPasswordValidator on SimpleValidationBuilder<String> {
  SimpleValidationBuilder<String> customValidPassword() {
    return notEmpty()
        .minLength(8)
        .mustHaveLowercase()
        .mustHaveUppercase()
        .mustHaveNumber()
        .mustHaveSpecialCharacter();
  }
}
