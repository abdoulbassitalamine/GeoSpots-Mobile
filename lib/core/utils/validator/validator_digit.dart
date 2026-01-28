import 'validator.dart';

class ValidatorDigit extends Validator {
  @override
  bool execute(String value) {
    return RegExp(kRegexOneNumber).hasMatch(value);
  }
}
