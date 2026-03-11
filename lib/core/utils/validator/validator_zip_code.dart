import 'validator.dart';

class ValidatorZipCode extends Validator {
  ValidatorZipCode();

  @override
  bool execute(String value) {
    return ValidatorRegex(kRegexFrZipCode).execute(value);
  }
}
