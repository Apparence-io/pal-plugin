import 'package:flutter/widgets.dart';

class CustomLabel {
  String text;
  Color fontColor;
  Color backgroundColor;
  Color borderColor;
  num fontSize;

  CustomLabel({
    this.text,
    @required this.fontColor,
    this.backgroundColor,
    this.borderColor,
    @required this.fontSize,
  });
}
