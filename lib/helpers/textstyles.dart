import 'package:flutter/material.dart';
import 'package:utility_extensions/extensions/font_utilities.dart';
import 'colors.dart';

class AppTextStyles {
  static TextStyle? popins({TextStyle? style}) {
    return style;
  }

  static TextStyle? field({required Color color}) {
    return TextStyle(
      color: color,
      fontWeight: FontWeights.light,
      fontSize: 18,
    );
  }

  static TextStyle? clickable(
      {Color color = CColors.primary, FontWeight weight = FontWeights.medium, double fontSize = 18}) {
    return TextStyle(
      color: color,
      fontWeight: weight,
      fontSize: fontSize,
    );
  }

  static TextStyle? heading({Color color = CColors.textColor}) {
    return TextStyle(
      color: color,
      height: 1.1,
      fontWeight: FontWeights.bold,
      fontSize: 40,
    );
  }

  static TextStyle? mini({required Color color}) {
    return TextStyle(
      color: color,
      fontSize: 12,
    );
  }

  static TextStyle? info({required Color color}) {
    return TextStyle(
      color: color,
      fontSize: 12,
    );
  }

  static TextStyle? message({required Color color,double fontSize = 16}) {
    return TextStyle(
      color: color,
      fontWeight: FontWeights.light,
      fontSize: fontSize,
    );
  }

  static TextStyle? title({required Color color, double fontSize = 24,FontWeight fontWeight = FontWeights.bold}) {
    return TextStyle(
      color: color,
      fontWeight: fontWeight,
      fontSize: fontSize,
    );
  }
}
