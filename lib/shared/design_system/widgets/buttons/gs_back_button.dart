import 'package:flutter/material.dart';
import 'package:geo_spots/shared/design_system/design_system.dart';

const double leadingWidth = 40;

class GSBackButton extends StatelessWidget {
  const GSBackButton({super.key, this.color, this.onPressed});

  final Color? color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed ?? () => Navigator.of(context).pop(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: GSSpacing.$200),
        child: Icon(
          Icons.arrow_back,
          color: color ?? GSColorTokens.textInverse,
        ),
      ),
    );
  }
}
