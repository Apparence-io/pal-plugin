import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/font_editor/pickers/font_weight_picker/font_weight_picker_loader.dart';

// Put all notifiers models here

class TextFormFieldNotifier {
  String hintText;
  ValueNotifier<String> text;
  ValueNotifier<String> fontFamily;
  ValueNotifier<String> fontWeight;
  ValueNotifier<Color> fontColor;
  ValueNotifier<Color> backgroundColor;
  ValueNotifier<Color> borderColor;
  ValueNotifier<int> fontSize;

  TextFormFieldNotifier({
    @required String text,
    @required Color fontColor,
    String fontFamily,
    String fontWeight,
    Color backgroundColor,
    Color borderColor,
    @required int fontSize,
    String hintText,
  }) {
    this.text = ValueNotifier(text);
    this.fontColor = ValueNotifier(fontColor);
    this.fontFamily = ValueNotifier(fontFamily ?? 'Montserrat');
    this.fontWeight = ValueNotifier(fontWeight ?? FontWeightMapper.toFontKey(FontWeight.normal));
    this.backgroundColor = ValueNotifier(backgroundColor ?? Colors.blueAccent);
    this.borderColor = ValueNotifier(borderColor);
    this.fontSize = ValueNotifier(fontSize ?? 14);
    this.hintText = hintText ?? text;
  }
}

class MediaNotifier {
  ValueNotifier<String> key;
  ValueNotifier<String> id;
  ValueNotifier<String> url;

  MediaNotifier({
    String key,
    String url,
    String id,
  }) {
    this.key = ValueNotifier(key);
    this.url = ValueNotifier(url);
    this.id = ValueNotifier(id);
  }
}
