import 'package:flutter/material.dart';

extension SizedboxExtension on int {
  Widget get toHeight => SizedBox(height: toDouble());

  Widget get toWidth => SizedBox(width: toDouble());
}
