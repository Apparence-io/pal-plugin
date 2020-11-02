import 'package:flutter/widgets.dart';

class CustomLabel {
  int id;
  String text;
  Color fontColor;
  // Color backgroundColor;
  // Color borderColor;
  double fontSize;
  String fontFamily;
  FontWeight fontWeight;
  

  CustomLabel({
    this.id,
    this.text,
    @required this.fontColor,
    // this.backgroundColor,
    // this.borderColor,
    @required this.fontSize,
    this.fontFamily,
    this.fontWeight
  });
}

// TODO: Create others model for box, image etc.