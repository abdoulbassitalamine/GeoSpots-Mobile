import 'validator.dart';

class ValidatorMinLength extends Validator {
  ValidatorMinLength({required this.minLength});

  final int minLength;

  @override
  bool execute(String value) {
    return value.length >= minLength;
  }
}