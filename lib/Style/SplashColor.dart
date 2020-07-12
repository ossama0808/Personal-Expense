import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Colors {
  const Colors();

  static Color loginGradientStart =  Color(0xFFd62ffd);
  static Color loginGradientEnd =  Color(0xFF6a197d);

  static  var primaryGradient =  LinearGradient(
    colors:  [loginGradientStart, loginGradientEnd],
    stops:  [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}