import 'package:flutter/material.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';



class HelperEntity {
  String id;
  DateTime creationDate;
  DateTime lastUpdateDate;
  String name;
  String pageId;
  int priority;
  HelperType type;
  HelperTriggerType triggerType;
  int versionMinId;
  String versionMin;
  int versionMaxId;
  String versionMax;
  List<HelperBorderEntity> helperBorders;
  List<HelperImageEntity> helperImages;
  List<HelperTextEntity> helperTexts;
  List<HelperBoxEntity> helperBoxes;

  HelperEntity({
    this.id,
    this.name,
    this.type,
    this.triggerType,
    this.creationDate,
    this.lastUpdateDate,
    this.priority,
    this.pageId,
    this.versionMinId,
    this.versionMin,
    this.versionMaxId,
    this.versionMax,
    this.helperBorders,
    this.helperImages,
    this.helperTexts,
    this.helperBoxes
  });

  factory HelperEntity.copy(HelperEntity from) {
    List<HelperBoxEntity> _helperBoxes = from.helperBoxes != null ? List() : null;
    if(_helperBoxes != null) {
      from.helperBoxes.forEach((el) => _helperBoxes.add(HelperBoxEntity()));
    }
    return HelperEntity(
      id: from.id,
      name: from.name,
      type: from.type,
      triggerType: from.triggerType,
      creationDate: from.creationDate,
      lastUpdateDate: from.lastUpdateDate,
      priority: from.priority,
      pageId: from.pageId,
      versionMinId: from.versionMinId,
      versionMin: from.versionMin,
      versionMaxId: from.versionMaxId,
      versionMax: from.versionMax,
      helperBorders: from.helperBorders,
      helperImages: from.helperImages,
      helperTexts: from.helperTexts,
      helperBoxes: _helperBoxes,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type.toString().split('.')[1],
    'triggerType': triggerType.toString().split('.')[1],
    'creationDate': creationDate != null ? creationDate.toIso8601String() : null,
    'lastUpdateDate': lastUpdateDate !=null ? lastUpdateDate.toIso8601String() : null,
    'priority': priority,
    'pageId': pageId,
    'versionMinId': versionMinId,
    'versionMin': versionMin,
    'versionMaxId': versionMaxId,
    'versionMax': versionMax,
    'helperBorders': helperBorders,
    'helperImages': helperImages,
    'helperTexts': helperTexts,
    'helperBoxes': helperBoxes,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HelperEntity &&
          id == other.id &&
          creationDate == other.creationDate &&
          lastUpdateDate == other.lastUpdateDate &&
          name == other.name &&
          pageId == other.pageId &&
          priority == other.priority &&
          type == other.type &&
          triggerType == other.triggerType &&
          versionMinId == other.versionMinId &&
          versionMin == other.versionMin &&
          versionMaxId == other.versionMaxId &&
          versionMax == other.versionMax &&
          helperBorders == other.helperBorders &&
          helperImages == other.helperImages &&
          helperBoxes == other.helperBoxes &&
          helperTexts == other.helperTexts;

  @override
  int get hashCode =>
      id.hashCode ^
      creationDate.hashCode ^
      lastUpdateDate.hashCode ^
      name.hashCode ^
      pageId.hashCode ^
      priority.hashCode ^
      type.hashCode ^
      triggerType.hashCode ^
      versionMinId.hashCode ^
      versionMin.hashCode ^
      versionMaxId.hashCode ^
      versionMax.hashCode ^
      helperBorders.hashCode ^
      helperImages.hashCode ^
      helperTexts.hashCode;
}

class HelperBorderEntity {
  int id;
  String color, key, style;
  double width;

  HelperBorderEntity({this.id, this.color, this.key, this.style, this.width});

  Map<String, dynamic> toJson() => {
    'id': id,
    'color': color,
    'key': key,
    'style': style,
    'width': width,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HelperBorderEntity &&
          id == other.id &&
          color == other.color &&
          key == other.key &&
          style == other.style &&
          width == other.width;

  @override
  int get hashCode =>
      id.hashCode ^
      color.hashCode ^
      key.hashCode ^
      style.hashCode ^
      width.hashCode;
}

class HelperImageEntity {
  int id;
  String key, url;

  Map<String, dynamic> toJson() => {
    'id': id,
    'key': key,
    'url': url,
  };

  HelperImageEntity({this.id, this.key, @required this.url});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HelperImageEntity &&
          id == other.id &&
          key == other.key &&
          url == other.url;

  @override
  int get hashCode => id.hashCode ^ key.hashCode ^ url.hashCode;
}

class HelperTextEntity {
  int id;
  String fontColor, fontFamily, fontWeight, key, value;
  int fontSize;

  HelperTextEntity({this.id, this.fontColor, this.fontFamily, this.fontWeight,
    this.key, this.value, this.fontSize});

  Map<String, dynamic> toJson() => {
    'id': id,
    'fontColor': fontColor,
    'fontFamily': fontFamily,
    'fontWeight': fontWeight,
    'fontSize': fontSize,
    'key': key,
    'value': value,
  };

  @override
  bool operator == (Object other) =>
      identical(this, other) ||
      other is HelperTextEntity &&
          id == other.id &&
          fontColor == other.fontColor &&
          fontFamily == other.fontFamily &&
          fontWeight == other.fontWeight &&
          key == other.key &&
          value == other.value &&
          fontSize == other.fontSize;

  @override
  int get hashCode =>
      id.hashCode ^
      fontColor.hashCode ^
      fontFamily.hashCode ^
      fontWeight.hashCode ^
      key.hashCode ^
      value.hashCode ^
      fontSize.hashCode;
}

class HelperBoxEntity {
  int id;
  String backgroundColor;
  String key;

  HelperBoxEntity({this.id, @required this.backgroundColor, @required this.key});

  Map<String, dynamic> toJson() => {
    'id': id,
    'backgroundColor': backgroundColor,
    'key': key,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HelperBoxEntity &&
          id == other.id &&
          backgroundColor == other.backgroundColor &&
          key == other.key;

  @override
  int get hashCode => id.hashCode ^ backgroundColor.hashCode ^ key.hashCode;

  factory HelperBoxEntity.copy(HelperBoxEntity from) {
    return HelperBoxEntity(
      id: from.id,
      backgroundColor: from.backgroundColor,
      key: from.key,
    );
  }
}