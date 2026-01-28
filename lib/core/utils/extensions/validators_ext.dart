import 'package:geo_spots/core/utils/validator/validator.dart';

extension ValidatorExt on Validator {
  static final _message = Expando<String>();

  void withErrorMessage(String message) => _message[this] = message;

  String? get errorMessage => _message[this];
}

extension ValidatorsExt on Validators {
  static final _message = Expando<String>();

  void withErrorMessage(String message) => _message[this] = message;

  String? get errorMessage => _message[this];

  ({bool isValid, String? message}) executeWithPriorityMessage(String value) {
    final invalidValidators = execute(value);
    return (
      isValid: invalidValidators.isEmpty,
      message: invalidValidators.firstOrNull?.errorMessage,
    );
  }
}
