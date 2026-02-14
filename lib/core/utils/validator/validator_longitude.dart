import 'validator.dart';

class ValidatorLongitude extends Validator {
  @override
  bool execute(String value) {
    final normalized = value.trim().replaceAll(',', '.');
    final parsed = double.tryParse(normalized);
    if (parsed == null) return false;
    return parsed >= -180 && parsed <= 180;
  }
}
