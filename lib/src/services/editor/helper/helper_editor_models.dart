import 'package:flutter/material.dart';
import 'package:palplugin/src/database/entity/helper/helper_trigger_type.dart';
import 'package:palplugin/src/database/entity/helper/helper_type.dart';

///-------------------------------
/// KEYS to link data to right element
///-------------------------------
class SimpleHelperKeys {
  static const CONTENT_KEY = "CONTENT";
   static const BACKGROUND_KEY = "BACKGROUND_KEY"; // mandatory
}

class FullscreenHelperKeys {
  static const TITLE_KEY = "TITLE_KEY"; // mandatory
  static const DESCRIPTION_KEY = "DESCRIPTION_KEY"; //TODO for next release
  static const POSITIV_KEY = "POSITIV_KEY"; // not mandatory
  static const NEGATIV_KEY = "NEGATIV_KEY"; // not mandatory
  static const IMAGE_KEY = "IMAGE_KEY"; // not mandatory
  static const BACKGROUND_KEY = "BACKGROUND_KEY"; // mandatory
}

class UpdatescreenHelperKeys {
  static const TITLE_KEY = "TITLE_KEY"; // mandatory
  static const LINES_KEY = "LINES_KEY"; //first mandatory
  static const POSITIV_KEY = "POSITIV_KEY"; // not mandatory
  static const NEGATIV_KEY = "NEGATIV_KEY"; //TODO to remove
  static const IMAGE_KEY = "IMAGE_KEY"; // not mandatory
  static const BACKGROUND_KEY = "BACKGROUND_KEY";// mandatory
}

///-------------------------------
/// Base helper config
///-------------------------------
class CreateHelperConfig {
  String pageId;
  String name;
  HelperTriggerType triggerType;
  HelperType helperType;
  int priority;
  int versionMinId;
  int versionMaxId;

  CreateHelperConfig({
    @required this.pageId,
    @required this.name,
    @required this.triggerType,
    @required this.helperType,
    this.priority,
    this.versionMinId,
    this.versionMaxId,
  });
}

///-------------------------------
/// Simple helper model
///-------------------------------
class CreateSimpleHelper {
  CreateHelperConfig config;
  String title;
  String fontColor;
  String fontWeight;
  String fontFamily;
  int fontSize;
  String backgroundColor;
  String borderColor;

  CreateSimpleHelper({
    @required this.config,
    @required this.title,
    @required this.fontColor,
    @required this.backgroundColor,
    @required this.fontFamily,
    @required this.fontWeight,
    @required this.fontSize,
    this.borderColor,
  });
}

///-------------------------------
/// Fullscreen helper model
///-------------------------------
class CreateFullScreenHelper {
  CreateHelperConfig config;
  HelperTextConfig title, description, positivButton, negativButton;
  String backgroundColor;
  String topImageUrl;

  CreateFullScreenHelper({
    @required this.config,
    @required this.title,
    @required this.description,
    this.positivButton,
    this.negativButton,
    @required this.backgroundColor,
    this.topImageUrl});
}

///-------------------------------
/// Update helper model
///-------------------------------
class CreateUpdateHelper {
  CreateHelperConfig config;
  HelperTextConfig title, positivButton, negativButton;
  List<HelperTextConfig> lines;
  String backgroundColor;
  String topImageId;
  String topImageUrl;

  CreateUpdateHelper({
    @required this.config,
    @required this.title,
    @required this.lines,
    @required this.topImageId,
    @required this.topImageUrl,
    this.positivButton,
    this.negativButton,
    this.backgroundColor,
});
}

///-------------------------------
/// Text model for all types
/// use this in helpers with multiple text
///-------------------------------
class HelperTextConfig {
  String text;
  String fontColor;
  String fontWeight;
  String fontFamily;
  int fontSize;

  HelperTextConfig({
    @required this.text,
    @required this.fontColor,
    @required this.fontWeight,
    @required this.fontFamily,
    @required this.fontSize
  });
}