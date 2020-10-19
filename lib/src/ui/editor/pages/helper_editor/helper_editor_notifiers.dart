import 'package:flutter/widgets.dart';

// Put all notifiers models here

class TextFormFieldNotifier {
  String hintText;
  ValueNotifier<String> text;
  ValueNotifier<String> fontFamily;
  ValueNotifier<String> fontWeight;
  ValueNotifier<Color> fontColor;
  ValueNotifier<Color> backgroundColor;
  ValueNotifier<Color> borderColor;
  ValueNotifier<num> fontSize;

  TextFormFieldNotifier({
    @required String text,
    @required Color fontColor,
    String fontFamily,
    String fontWeight,
    Color backgroundColor,
    Color borderColor,
    @required num fontSize,
    String hintText,
  }) {
    this.text = ValueNotifier(text);
    this.fontColor = ValueNotifier(fontColor);
    this.fontFamily = ValueNotifier(fontFamily);
    this.fontWeight = ValueNotifier(fontWeight);
    this.backgroundColor = ValueNotifier(backgroundColor);
    this.borderColor = ValueNotifier(borderColor);
    this.fontSize = ValueNotifier(fontSize);
    this.hintText = hintText ?? text;
  }
}
