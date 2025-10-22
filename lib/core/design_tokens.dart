import 'package:flutter/material.dart';

class AppColors {
  static const bg = Color(0xFFF6F8FC);
  static const surface = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF101828);
  static const textSecondary = Color(0xFF6B7280);
  static const border = Color(0xFFE6EAF0);
  static const blue = Color(0xFF2EA6FF);
  static const blueDark = Color(0xFF117BDB);
  static const blueSoft = Color(0xFFE6F3FF);
  static const success = Color(0xFF2EC36A);
  static const warning = Color(0xFFFDB022);
  static const danger = Color(0xFFF04438);
}

class AppRadii {
  static const xxl = 28.0;
  static const xl = 22.0;
  static const lg = 18.0;
  static const md = 14.0;
  static const sm = 10.0;
  static const chip = 20.0;
  static const bottomBar = 26.0;
}

class AppShadows {
  static const soft = [
    BoxShadow(
      color: Color.fromRGBO(16, 24, 40, 0.06),
      offset: Offset(0, 6),
      blurRadius: 24,
    ),
  ];

  static const card = [
    BoxShadow(
      color: Color.fromRGBO(16, 24, 40, 0.08),
      offset: Offset(0, 10),
      blurRadius: 30,
    ),
  ];
}

class AppMotion {
  static const fast = Duration(milliseconds: 150);
  static const base = Duration(milliseconds: 220);
  static const slow = Duration(milliseconds: 300);
  static const curve = Cubic(0.2, 0.8, 0.2, 1.0);
}

class AppGradients {
  static const blueCapsule = [AppColors.blue, AppColors.blueDark];
  static const blueGlass = [
    Color.fromRGBO(46, 166, 255, 0.90),
    Color.fromRGBO(17, 123, 219, 0.90),
  ];
}

class AppTypography {
  static const double h1 = 24;
  static const double h2 = 20;
  static const double h3 = 18;
  static const double body = 14;
  static const double label = 12;
}
