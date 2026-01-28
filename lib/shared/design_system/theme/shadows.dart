import 'package:flutter/material.dart';
import 'colors.dart';

enum GSShadowsDirection { top, bottom }

/// Shadow system for GeoSpots
class GSShadows {
  GSShadows._();

  static BoxShadow xs({
    GSShadowsDirection direction = GSShadowsDirection.bottom,
    Color? color,
  }) => BoxShadow(
    color: color ?? GSColors.neutral1000.withValues(alpha: 0.15),
    offset: switch (direction) {
      GSShadowsDirection.top => const Offset(0, -3),
      GSShadowsDirection.bottom => const Offset(0, 3),
    },
    blurRadius: 5,
    spreadRadius: -2,
  );

  static BoxShadow s({
    GSShadowsDirection direction = GSShadowsDirection.bottom,
    Color? color,
  }) => BoxShadow(
    color: color ?? GSColors.neutral1000.withValues(alpha: 0.20),
    offset: switch (direction) {
      GSShadowsDirection.top => const Offset(0, -5),
      GSShadowsDirection.bottom => const Offset(0, 5),
    },
    blurRadius: 10,
    spreadRadius: -2,
  );

  static BoxShadow m({
    GSShadowsDirection direction = GSShadowsDirection.bottom,
    Color? color,
  }) => BoxShadow(
    color: color ?? GSColors.neutral1000.withValues(alpha: 0.20),
    offset: switch (direction) {
      GSShadowsDirection.top => const Offset(0, -10),
      GSShadowsDirection.bottom => const Offset(0, 10),
    },
    blurRadius: 20,
    spreadRadius: -4,
  );

  static BoxShadow l({
    GSShadowsDirection direction = GSShadowsDirection.bottom,
    Color? color,
  }) => BoxShadow(
    color: color ?? GSColors.neutral1000.withValues(alpha: 0.20),
    offset: switch (direction) {
      GSShadowsDirection.top => const Offset(0, -20),
      GSShadowsDirection.bottom => const Offset(0, 20),
    },
    blurRadius: 40,
    spreadRadius: -8,
  );

  static BoxShadow xl({
    GSShadowsDirection direction = GSShadowsDirection.bottom,
    Color? color,
  }) => BoxShadow(
    color: color ?? GSColors.neutral1000.withValues(alpha: 0.25),
    offset: switch (direction) {
      GSShadowsDirection.top => const Offset(0, -4),
      GSShadowsDirection.bottom => const Offset(0, 4),
    },
    blurRadius: 10,
    spreadRadius: -3,
  );
}
