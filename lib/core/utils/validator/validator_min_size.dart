import 'validator.dart';

class ValidatorMinSize extends Validator {
  ValidatorMinSize(this.size);

  final int size;

  @override
  bool execute(String value) {
    return value.length >= size;
  }
}

const int kMinPasswordLength = 8;
