import 'package:flutter/widgets.dart';

class CustomLabel {
  String text;
  Color fontColor;
  Color backgroundColor;
  Color borderColor;
  double fontSize;
  String fontFamily;
  String fontWeight;
  

  CustomLabel({
    this.text,
    @required this.fontColor,
    this.backgroundColor,
    this.borderColor,
    @required this.fontSize,
    this.fontFamily,
    this.fontWeight
  });
}
