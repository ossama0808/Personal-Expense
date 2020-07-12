import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Colors {
  const Colors();

  static Color loginGradientStart =  Color(0xFF690f7e);
  static Color loginGradientEnd =  Color(0xFF400a4d);

  static  var primaryGradient =  LinearGradient(
    colors:  [loginGradientStart, loginGradientEnd],
    stops:  [0.0, 8.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}