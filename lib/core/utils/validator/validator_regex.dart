import 'validator.dart';

class ValidatorRegex extends Validator {
  ValidatorRegex(this.regex);

  final String regex;

  @override
  bool execute(String value) {
    final regExp = RegExp(regex);
    return regExp.hasMatch(value);
  }
}

const String kRegexOneLowerCase = r'(?=.*[a-z])';
const String kRegexOneUpperCase = r'(?=.*[A-Z])';
const String kRegexOneNumber = r'(?=.*\d)';
const String kRegexOneSpeChar = r'(?=.*?[!@#$%^&*(),.?":{}|<>])';
const String kRegexFrPhoneNumber =
    r'^(?:(?:\+|00)33[\s.-]{0,3}(?:\(0\)[\s.-]{0,3})?|0)[1-9](?:(?:[\s.-]?\d{2}){4}|\d{2}(?:[\s.-]?\d{3}){2})$';
const String kRegexFrZipCode = r'^(?:0[1-9]|[1-8]\d|9[0-8])\d{3}$';
const String kRegexBrZipCode = r'^\d{5}-\d{3}$';
const String kRegexOnlyDigits = r'^\d+$';
