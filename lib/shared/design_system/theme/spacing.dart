/// GeoSpots spacing scale
class GSSpacing {
  GSSpacing._();

  static const double none = 0;
  static const double xs = 2;     // $25
  static const double s = 4;      // $50
  static const double m = 8;      // $100
  static const double l = 12;     // $150
  static const double xl = 16;    // $200
  static const double xl2 = 20;   // $250
  static const double xl3 = 24;   // $300
  static const double xl4 = 32;   // $400
  static const double xl5 = 40;   // $500
  static const double xl6 = 48;   // $600
  static const double xl7 = 56;   // $700
  static const double xl8 = 64;   // $800
  static const double xl9 = 72;   // $900
  static const double xl10 = 80;  // $1000
  static const double xl11 = 88;  // $1100
  static const double xl12 = 96;  // $1200

  // Legacy naming for compatibility
  static const double $25 = xs;
  static const double $50 = s;
  static const double $100 = m;
  static const double $150 = l;
  static const double $200 = xl;
  static const double $250 = xl2;
  static const double $300 = xl3;
  static const double $400 = xl4;
  static const double $500 = xl5;
  static const double $600 = xl6;
  static const double $700 = xl7;
  static const double $800 = xl8;
  static const double $900 = xl9;
  static const double $1000 = xl10;
  static const double $1100 = xl11;
  static const double $1200 = xl12;
}

/// Border radius values
class GSRadius {
  GSRadius._();

  static const double none = 0;
  static const double xs = 2;
  static const double s = 4;
  static const double m = 8;
  static const double l = 16;
  static const double full = 1000;
}

/// Border width values
class GSBorderWidth {
  GSBorderWidth._();

  static const double s = 1;
  static const double m = 2;
  static const double l = 4;
}

/// Elevation values
class GSElevation {
  GSElevation._();

  static const double s = 2;
  static const double m = 4;
  static const double l = 6;
}

/// Stroke width values
class GSStroke {
  GSStroke._();

  static const double s = 1;
  static const double m = 2;
  static const double l = 3;
}

/// Aspect ratios
class GSAspectRatios {
  GSAspectRatios._();

  static const double r16_9 = 16 / 9;
  static const double r3_2 = 3 / 2;
  static const double r4_3 = 4 / 3;
  static const double r1_1 = 1 / 1;
  static const double r3_4 = 3 / 4;
  static const double r2_3 = 2 / 3;
}