import 'package:flutter/widgets.dart';

class GroupViewModel {
  int index;
  int steps;

  GroupViewModel({
    required this.index,
    required this.steps
  });
}

class HelperTextViewModel {
  int? id;
  String? key;
  String? text;
  Color? fontColor;
  double? fontSize;
  String? fontFamily;
  FontWeight? fontWeight;

  HelperTextViewModel({
    this.id,
    this.text,
    this.key,
    required this.fontColor,
    required this.fontSize,
    this.fontFamily,
    this.fontWeight,
  });
}

enum HelperButtonStyle {
  TEXT, BORDERED, COLORED
}

class HelperButtonViewModel {
  int? id;
  String? key;
  String? text;
  Color? fontColor;
  double? fontSize;
  String? fontFamily;
  FontWeight? fontWeight;
  Color? borderColor;
  Color? backgroundColor;
  HelperButtonStyle buttonStyle;

  HelperButtonViewModel({
    this.id,
    this.text,
    this.key,
    required this.fontColor,
    required this.fontSize,
    this.fontFamily,
    this.fontWeight,
    this.backgroundColor,
    this.borderColor,
    HelperButtonStyle? buttonStyle
  }): this.buttonStyle = buttonStyle ?? HelperButtonStyle.BORDERED;
}

class HelperImageViewModel {
  int? id;
  String? url;

  HelperImageViewModel({
    this.id,
    required this.url,
  });
}

class HelperBoxViewModel {
  int? id;
  Color? backgroundColor;

  HelperBoxViewModel({
    this.id,
    required this.backgroundColor,
  });
}

class HelperBorderViewModel {
  int? id;
  Color? color;
  String? style;
  double? width;

  HelperBorderViewModel({
    this.id,
    this.color,
    this.style,
    this.width,
  });
}
