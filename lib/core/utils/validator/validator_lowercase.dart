import 'validator.dart';

class ValidatorLowercase extends Validator {
  @override
  bool execute(String value) {
    return RegExp(kRegexOneLowerCase).hasMatch(value);
  }
}
