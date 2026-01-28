import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import 'validator.dart';

class ValidatorPhone extends Validator {
  ValidatorPhone();

  @override
  bool execute(String value) {
    if (value.isEmpty) {
      return true;
    }
    final phone = PhoneNumber.parse(value);

    return phone.isValid();
  }
}
