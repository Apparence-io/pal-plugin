import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/pickers/font_editor/pickers/font_weight_picker/font_weight_picker_loader.dart';

abstract class EditableData {
  int? id;
  String? key;
  bool? isSelected;

  EditableData(this.id, this.key);
}

abstract class EditableTextData extends EditableData {
  String? text;
  String? fontFamily;
  String? fontWeight;
  Color? fontColor;
  int? fontSize;

  EditableTextData(
    int? id,
    String key, {
    required this.text,
    required this.fontColor,
    String? fontFamily,
    String? fontWeight,
    required this.fontSize,
    String? hintText,
  }) : super(id, key) {
    this.fontWeight = fontWeight != null
        ? fontWeight
        : FontWeightMapper.toFontKey(FontWeight.normal);
    this.fontFamily = fontFamily != null ? fontFamily : 'Montserrat';
  }
}

class EditableButtonFormData extends EditableTextData {
  Color? borderColor;
  Color? backgroundColor;

  EditableButtonFormData(
    int? id,
    String key, {
    required String text,
    required Color fontColor,
    String? fontFamily,
    String? fontWeight,
    Color? backgroundColor,
    Color? borderColor,
    required int fontSize,
    String? hintText,
  }) : super(
          id,
          key,
          fontColor: fontColor,
          fontSize: fontSize,
          fontFamily: fontFamily,
          fontWeight: fontWeight,
          hintText: hintText,
          text: text,
        ) {
    this.borderColor = borderColor;
    this.backgroundColor = backgroundColor;
  }
}

class EditableTextFormData extends EditableTextData {
  EditableTextFormData(
    int? id,
    String key, {
    required String text,
    required Color fontColor,
    String? fontFamily,
    String? fontWeight,
    required int fontSize,
    String? hintText,
  }) : super(
          id,
          key,
          fontColor: fontColor,
          fontSize: fontSize,
          fontFamily: fontFamily,
          fontWeight: fontWeight,
          hintText: hintText,
          text: text,
        );
}

class EditableMediaFormData extends EditableData {
  String? uuid;
  String? url;

  EditableMediaFormData(
    int? id,
    String key, {
    String? url,
    String? uuid,
  }) : super(id, key) {
    this.uuid = uuid;
    this.url = url;
  }
}

// class LanguageNotifier extends EditableData {
//   // TODO: Create an ID ?

//   LanguageNotifier({
//     int id,
//   }) : super(id) {
//     this.id = id;
//   }
// }

class EditableBoxFormData extends EditableData {
  Color? backgroundColor;

  EditableBoxFormData(
    int? id,
    String? key, {
    Color? backgroundColor,
  }) : super(id, key) {
    this.backgroundColor = backgroundColor ?? Colors.blueAccent;
  }
}

class EditableBorderFormData extends EditableData {
  Color? color;
  String? style;
  double? width;
  EditableBorderFormData(int id, String key, {this.color, this.style})
      : super(id, key);
}
