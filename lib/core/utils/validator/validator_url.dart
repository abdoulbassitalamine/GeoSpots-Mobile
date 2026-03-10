import 'validator.dart';

class ValidatorUrl extends Validator {
  @override
  bool execute(String value) {
    final uri = Uri.tryParse(value.trim());
    return uri != null && uri.hasScheme && uri.host.isNotEmpty;
  }
}
