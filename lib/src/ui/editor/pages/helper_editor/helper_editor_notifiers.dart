import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/font_editor/pickers/font_weight_picker/font_weight_picker_loader.dart';

// Put all notifiers models here

class TextFormFieldNotifier {
  String hintText;
  int id;
  ValueNotifier<String> text;
  ValueNotifier<String> fontFamily;
  ValueNotifier<String> fontWeight;
  ValueNotifier<Color> fontColor;
  ValueNotifier<Color> backgroundColor;
  ValueNotifier<Color> borderColor;
  ValueNotifier<int> fontSize;

  TextFormFieldNotifier({
    int id,
    @required String text,
    @required Color fontColor,
    String fontFamily,
    String fontWeight,
    Color backgroundColor,
    Color borderColor,
    @required int fontSize,
    String hintText,
  }) {
    this.id = id;
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
  int id;
  String uuid;
  // ValueNotifier<String> key;
  ValueNotifier<String> url;

  MediaNotifier({
    // String key,
    String url,
    int id,
    String uuid,
  }) {
    this.id = id;
    this.uuid = uuid;
    // this.key = ValueNotifier(key);
    this.url = ValueNotifier(url);
  }
}

class LanguageNotifier {
  int id;
  // TODO: Create an ID ?

  LanguageNotifier({
    int id,
  }) {
    this.id = id;
  }
}

class BoxNotifier {
  int id;
  ValueNotifier<Color> backgroundColor;

  BoxNotifier({
    int id,
    Color backgroundColor
  }) {
    this.id = id;
    this.backgroundColor = ValueNotifier(backgroundColor ?? Colors.blueAccent);
  }
}

// TODO: Create border notifier