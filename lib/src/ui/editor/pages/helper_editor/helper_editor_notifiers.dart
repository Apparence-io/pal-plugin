import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/pickers/font_editor/pickers/font_weight_picker/font_weight_picker_loader.dart';

// Put all notifiers models here
class FormFieldNotifier {
  int id;

  FormFieldNotifier(this.id);
}

class EditableFormFieldNotifier extends FormFieldNotifier {
  // String hintText;
  ValueNotifier<String> text;
  ValueNotifier<String> fontFamily;
  ValueNotifier<String> fontWeight;
  ValueNotifier<Color> fontColor;
  // ValueNotifier<Color> backgroundColor;
  // ValueNotifier<Color> borderColor;
  ValueNotifier<int> fontSize;
  
  // FocusNode focusNode;
  // ValueNotifier<bool> toolbarVisibility;

  EditableFormFieldNotifier(
    int id, {
    @required String text,
    @required Color fontColor,
    String fontFamily,
    String fontWeight,
    // Color backgroundColor,
    // Color borderColor,
    @required int fontSize,
    String hintText
  }) : super(id) {
    this.text = ValueNotifier(text);
    this.fontColor = ValueNotifier(fontColor);
    // this.toolbarVisibility = ValueNotifier(false);
    this.fontFamily = ValueNotifier(fontFamily ?? 'Montserrat');
    this.fontWeight = ValueNotifier(
        fontWeight ?? FontWeightMapper.toFontKey(FontWeight.normal));
    // this.backgroundColor = ValueNotifier(backgroundColor ?? Colors.blueAccent);
    // this.borderColor = ValueNotifier(borderColor);
    this.fontSize = ValueNotifier(fontSize ?? 14);
    // this.hintText = hintText ?? text;
    // this.focusNode = FocusNode();
  }
}

class ButtonFormFieldNotifier extends EditableFormFieldNotifier {
  ValueNotifier<Color> borderColor;
  ValueNotifier<Color> backgroundColor;

  ButtonFormFieldNotifier(
    int id, {
    @required String text,
    @required Color fontColor,
    String fontFamily,
    String fontWeight,
    Color backgroundColor,
    Color borderColor,
    @required int fontSize,
    String hintText,
  }) : super(
          id,
          fontColor: fontColor,
          fontSize: fontSize,
          fontFamily: fontFamily,
          fontWeight: fontWeight,
          hintText: hintText,
          text: text,
        ) {
    this.borderColor = ValueNotifier(borderColor);
    this.backgroundColor = ValueNotifier(backgroundColor);
  }
}

class TextFormFieldNotifier extends EditableFormFieldNotifier {
  TextFormFieldNotifier(
    int id, {
    @required String text,
    @required Color fontColor,
    String fontFamily,
    String fontWeight,
    @required int fontSize,
    String hintText,
  }) : super(
          id,
          fontColor: fontColor,
          fontSize: fontSize,
          fontFamily: fontFamily,
          fontWeight: fontWeight,
          hintText: hintText,
          text: text,
        );
}

class MediaNotifier extends FormFieldNotifier {
  String uuid;
  ValueNotifier<String> url;

  MediaNotifier({
    // String key,
    String url,
    int id,
    String uuid,
  }) : super(id) {
    this.uuid = uuid;
    this.url = ValueNotifier(url);
  }
}

class LanguageNotifier extends FormFieldNotifier {
  // TODO: Create an ID ?

  LanguageNotifier({
    int id,
  }) : super(id) {
    this.id = id;
  }
}

class BoxNotifier extends FormFieldNotifier {
  String key;
  ValueNotifier<Color> backgroundColor;

  BoxNotifier({
    int id,
    this.key,
    Color backgroundColor,
  }) : super(id) {
    this.backgroundColor = ValueNotifier(backgroundColor ?? Colors.blueAccent);
  }
}

// TODO: Create border notifier
