import 'package:flutter/material.dart';
import 'package:geo_spots/gen/assets.gen.dart';

class LogoCyberDefense extends StatelessWidget {
  const LogoCyberDefense({super.key, this.width = 300, this.height = 100});
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return GSIcons.icons.logoGeoSpotsHr.svg(width: width, height: height);
  }
}
