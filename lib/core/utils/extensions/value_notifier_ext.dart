import 'package:flutter/material.dart';

extension ValueNotifierExt on ValueNotifier<Object?> {
  void clear() => value = null;
}

extension ValueNotifierStringExt on ValueNotifier<String?> {
  String? notEmptyOrNull() => (value?.isEmpty ?? true) ? null : value;
}
