import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';

///-------------------------------
/// Base helper config
///-------------------------------
class CreateHelperConfig {
  String id;
  String route;
  String name;
  HelperTriggerType triggerType;
  HelperType helperType; //remove
  int priority;
  String minVersion;
  String maxVersion;

  CreateHelperConfig({
    this.id,
    @required this.route,
    @required this.name,
    @required this.triggerType,
    @required this.helperType,
    this.priority,
    this.minVersion,
    this.maxVersion,
  });

  factory CreateHelperConfig.from(String route, HelperViewModel viewModel)
    => CreateHelperConfig(
      id: viewModel?.id,
      route: route,
      name: viewModel.name,
      triggerType: viewModel?.helperGroup?.triggerType,
      helperType: viewModel?.helperType,
      priority: viewModel?.priority,
      minVersion: viewModel?.helperGroup?.minVersionCode,
      maxVersion: viewModel?.helperGroup?.maxVersionCode,
    );

  toJson() => {
    "id": id,
    "route": route,
    "name": name,
    "triggerType": triggerType.toString(),
    "helperType": helperType.toString(),
    "priority": priority,
    "minVersion": minVersion,
    "maxVersion": maxVersion,
  }; 
}

///-------------------------------
/// Simple helper model
///-------------------------------
class CreateSimpleHelper {
  CreateHelperConfig config;
  HelperTextConfig titleText;
  HelperBoxConfig boxConfig;

  CreateSimpleHelper({
    @required this.config,
    @required this.titleText,
    @required this.boxConfig,
  });
}

///-------------------------------
/// Fullscreen helper model
///-------------------------------
class CreateFullScreenHelper {
  CreateHelperConfig config;
  HelperTextConfig title, description, positivButton, negativButton;
  HelperMediaConfig mediaHeader;
  HelperBoxConfig bodyBox;

  CreateFullScreenHelper({
    @required this.config,
    @required this.title,
    @required this.description,
    this.positivButton,
    this.negativButton,
    @required this.bodyBox,
    this.mediaHeader,
  });
}

///-------------------------------
/// Update helper model
///-------------------------------
class CreateUpdateHelper {
  CreateHelperConfig config;
  HelperTextConfig title, positivButton, negativButton;
  List<HelperTextConfig> lines;
  HelperBoxConfig bodyBox;
  HelperMediaConfig headerMedia;

  CreateUpdateHelper({
    @required this.config,
    @required this.title,
    @required this.lines,
    @required this.headerMedia,
    this.positivButton,
    this.negativButton,
    this.bodyBox,
  });
}

///-------------------------------
/// AnchoredHelper helper model
///-------------------------------
class CreateAnchoredHelper {
  CreateHelperConfig config;
  HelperTextConfig title, description, positivButton, negativButton;
  HelperBoxConfig bodyBox;

  CreateAnchoredHelper({
    this.config,
    this.title,
    this.description,
    this.positivButton, this.negativButton,
    this.bodyBox
  });

  toJson() => {
    "config": jsonEncode(config),
    "title": jsonEncode(title),
    "description": jsonEncode(description),
    "positivButton": jsonEncode(positivButton),
    "negativButton": jsonEncode(negativButton),
    "bodyBox": jsonEncode(bodyBox),
  };
}

///-------------------------------
/// Text model for all types
/// use this in helpers with multiple text
///-------------------------------
class HelperTextConfig {
  int id;
  String text;
  String fontColor;
  String fontWeight;
  String fontFamily;
  int fontSize;

  HelperTextConfig(
      {this.id,
      @required this.text,
      @required this.fontColor,
      @required this.fontWeight,
      @required this.fontFamily,
      @required this.fontSize});

  toJson() => {
    "id": id,
    "text": text,
    "fontColor": fontColor,
    "fontWeight": fontWeight,
    "fontSize": fontSize
  };

}

class HelperMediaConfig {
  int id;
  String url;

  HelperMediaConfig({
    this.id,
    this.url,
  });
}

class HelperBoxConfig {
  int id;
  String key;
  String color;
  // TODO: Missing params ?

  HelperBoxConfig({
    this.id,
    this.key,
    this.color,
  });

  toJson() => {
    "id":id,
    "key":key,
    "color":color
  };
}