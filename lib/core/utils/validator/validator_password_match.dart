import 'validator.dart';

class ValidatorPasswordMatch extends Validator {
  ValidatorPasswordMatch({required this.getPasswordToMatch});
  final String Function() getPasswordToMatch;

  @override
  bool execute(String value) {
    return value == getPasswordToMatch();
  }
}
