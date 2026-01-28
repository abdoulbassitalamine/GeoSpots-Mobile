import 'validator.dart';

class ValidatorSpecialChar extends Validator {
  @override
  bool execute(String value) {
    return RegExp(kRegexOneSpeChar).hasMatch(value);
  }
}
