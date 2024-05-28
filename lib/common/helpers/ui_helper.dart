import 'package:flutter/material.dart';

class UIHelper {
  static double _deviceWidth = 0.0;
  static double _deviceHeight = 0.0;
  static late BorderRadiusGeometry _borderRadius;

  static void initialize(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    _borderRadius = const BorderRadius.all(Radius.circular(10));
  }

  static double get deviceWidth => _deviceWidth;
  static double get deviceHeight => _deviceHeight;
  static BorderRadiusGeometry get borderRadius => _borderRadius;
}
