export 'validator_digit.dart';
export 'validator_email.dart';
export 'validator_latitude.dart';
export 'validator_longitude.dart';
export 'validator_lowercase.dart';
export 'validator_min_length.dart';
export 'validator_min_size.dart';
export 'validator_password.dart';
export 'validator_password_match.dart';
export 'validator_phone.dart';
export 'validator_regex.dart';
export 'validator_required.dart';
export 'validator_special_char.dart';
export 'validator_uppercase.dart';
export 'validator_url.dart';
export 'validator_zip_code.dart';

abstract class Validator {
  bool execute(String value);
}

class Validators {
  const Validators({this.validators = const []});

  final List<Validator> validators;

  List<Validator> execute(String value) {
    final errors = <Validator>[];
    for (final validator in validators) {
      final error = validator.execute(value);
      if (!error) {
        errors.add(validator);
      }
    }

    return errors;
  }
}
