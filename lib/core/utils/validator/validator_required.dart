import 'validator.dart';

class ValidatorRequired extends Validator {
  ValidatorRequired();

  @override
  bool execute(String value) {
    return value.isNotEmpty;
  }
}
