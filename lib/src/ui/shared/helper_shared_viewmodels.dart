import 'package:flutter/widgets.dart';

class HelperTextViewModel {
  int id;
  String text;
  Color fontColor;
  double fontSize;
  String fontFamily;
  FontWeight fontWeight;

  HelperTextViewModel({
    this.id,
    this.text,
    @required this.fontColor,
    @required this.fontSize,
    this.fontFamily,
    this.fontWeight,
  });
}

class HelperImageViewModel {
  int id;
  String url;

  HelperImageViewModel({
    this.id,
    @required this.url,
  });
}

class HelperBoxViewModel {
  int id;
  Color backgroundColor;

  HelperBoxViewModel({
    this.id,
    @required this.backgroundColor,
  });
}

class HelperBorderViewModel {
  int id;
  Color color;
  String style;
  double width;

  HelperBorderViewModel({
    this.id,
    this.color,
    this.style,
    this.width,
  });
}
