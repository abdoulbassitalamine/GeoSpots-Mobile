import 'validator.dart';

class ValidatorUppercase extends Validator {
  @override
  bool execute(String value) {
    return RegExp(kRegexOneUpperCase).hasMatch(value);
  }
}
