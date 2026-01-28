import 'validator.dart';

class ValidatorPassword extends Validator {
  ValidatorPassword({
    this.minLength = kMinPasswordLength,
    this.requireUppercase = true,
    this.requireLowercase = true,
    this.requireDigit = true,
    this.requireSpecialChar = true,
  });

  final int minLength;
  final bool requireUppercase;
  final bool requireLowercase;
  final bool requireDigit;
  final bool requireSpecialChar;

  @override
  bool execute(String value) {
    // Check minimum length
    if (value.length < minLength) {
      return false;
    }

    // Build regex pattern based on requirements
    var pattern = '^';

    if (requireUppercase) {
      pattern += kRegexOneUpperCase;
    }

    if (requireLowercase) {
      pattern += kRegexOneLowerCase;
    }

    if (requireDigit) {
      pattern += kRegexOneNumber;
    }

    if (requireSpecialChar) {
      pattern += kRegexOneSpeChar;
    }

    pattern += r'.+$';

    // Validate against the pattern
    final regexValidator = ValidatorRegex(pattern);
    return regexValidator.execute(value);
  }
}