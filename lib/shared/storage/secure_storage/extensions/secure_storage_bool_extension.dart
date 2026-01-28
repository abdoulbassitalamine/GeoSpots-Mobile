const kSecureStorageTrueValue = 'true';
const kSecureStorageFalseValue = 'false';

extension SecureStorageBoolExtension on bool {
  String toSecureStorageValue() =>
      this ? kSecureStorageTrueValue : kSecureStorageFalseValue;
}

extension SecureStorageStringExtension on String? {
  bool toSecureStorageBool({bool defaultValue = true}) {
    if (this == null) return defaultValue;
    return this == kSecureStorageTrueValue;
  }
}
