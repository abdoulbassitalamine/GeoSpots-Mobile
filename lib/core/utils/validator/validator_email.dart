import 'package:email_validator/email_validator.dart';

import 'validator.dart';

class ValidatorEmail extends Validator {
  ValidatorEmail();

  @override
  bool execute(String value) {
    return EmailValidator.validate(value);
  }
}
