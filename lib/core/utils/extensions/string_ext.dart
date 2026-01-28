extension StringExt on String? {
  bool get isNullOrEmpty => (this ?? '').isEmpty;

  bool get isOnlyDigits => this == null ? false : RegExp(r'^\d+$').hasMatch(this!);
}
