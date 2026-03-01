import 'package:flutter/material.dart';

abstract final class QBTokens {
  static const Color primary = Color(0xFFF1277B);
  static const Color backgroundLight = Color(0xFFF8F6F7);
  static const Color backgroundDark = Color(0xFF221017);
  static const Color backgroundDarkAlt = Color(0xFF1A0B11);

  static const double maxPhoneWidth = 430;
  static const Radius radiusXs = Radius.circular(4);
  static const Radius radiusSm = Radius.circular(8);
  static const Radius radiusMd = Radius.circular(12);
  static const Radius radiusLg = Radius.circular(16);
  static const Radius radiusXl = Radius.circular(24);

  static const Duration buttonAnimDuration = Duration(milliseconds: 140);
}
