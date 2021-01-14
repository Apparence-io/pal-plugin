import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/pickers/font_editor/pickers/font_weight_picker/font_weight_picker_loader.dart';

// Put all notifiers models here

class TextFormFieldNotifier {
  String hintText;
  int id;
  ValueNotifier<String> text;
  ValueNotifier<String> fontFamily;
  ValueNotifier<String> fontWeight;
  ValueNotifier<Color> fontColor;
  // ValueNotifier<Color> backgroundColor;
  // ValueNotifier<Color> borderColor;
  ValueNotifier<int> fontSize;
  // FocusNode focusNode;
  // ValueNotifier<bool> toolbarVisibility;

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
    // this.toolbarVisibility = ValueNotifier(false);
    this.fontFamily = ValueNotifier(fontFamily ?? 'Montserrat');
    this.fontWeight = ValueNotifier(fontWeight ?? FontWeightMapper.toFontKey(FontWeight.normal));
    // this.backgroundColor = ValueNotifier(backgroundColor ?? Colors.blueAccent);
    // this.borderColor = ValueNotifier(borderColor);
    this.fontSize = ValueNotifier(fontSize ?? 14);
    this.hintText = hintText ?? text;
    // this.focusNode = FocusNode();
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
  String key;
  ValueNotifier<Color> backgroundColor;

  BoxNotifier({
    this.id,
    this.key,
    Color backgroundColor,
  }) {
    this.backgroundColor = ValueNotifier(backgroundColor ?? Colors.blueAccent);
  }
}

class ButtonFormFieldNotifier {
  int id;
  ValueNotifier<String> text;
  ValueNotifier<String> fontFamily;
  ValueNotifier<String> fontWeight;
  ValueNotifier<Color> fontColor;
  ValueNotifier<Color> backgroundColor;
  ValueNotifier<Color> borderColor;
  ValueNotifier<int> fontSize;

  ButtonFormFieldNotifier({
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
  }
}

// TODO: Create border notifier