import 'validator.dart';

class ValidatorLatitude extends Validator {
  @override
  bool execute(String value) {
    final normalized = value.trim().replaceAll(',', '.');
    final parsed = double.tryParse(normalized);
    if (parsed == null) return false;
    return parsed >= -90 && parsed <= 90;
  }
}
