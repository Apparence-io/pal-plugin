import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';

part 'helper_entity.g.dart';

@HiveType(typeId: 3)
class HelperEntity {

  @HiveField(0)
  String id;

  @HiveField(1)
  DateTime creationDate;

  @HiveField(2)
  DateTime lastUpdateDate;

  @HiveField(3)
  String name;

  @HiveField(5)
  int priority;

  @HiveField(6)
  HelperType type;

  @HiveField(7)
  HelperTriggerType triggerType;

  @HiveField(8)
  int versionMinId;

  @HiveField(9)
  String versionMin;

  @HiveField(10)
  int versionMaxId;

  @HiveField(11)
  String versionMax;

  @HiveField(12)
  List<HelperBorderEntity> helperBorders;

  @HiveField(13)
  List<HelperImageEntity> helperImages;

  @HiveField(14)
  List<HelperTextEntity> helperTexts;

  @HiveField(15)
  List<HelperBoxEntity> helperBoxes;

  HelperEntity(
      {this.id,
      this.name,
      this.type,
      this.triggerType,
      this.creationDate,
      this.lastUpdateDate,
      this.priority,
      this.versionMinId,
      this.versionMin,
      this.versionMaxId,
      this.versionMax,
      this.helperBorders,
      this.helperImages,
      this.helperTexts,
      this.helperBoxes});

  factory HelperEntity.copy(HelperEntity from) {
    return HelperEntity(
      id: from.id,
      name: from.name,
      type: from.type,
      triggerType: from.triggerType,
      creationDate: from.creationDate,
      lastUpdateDate: from.lastUpdateDate,
      priority: from.priority,
      versionMinId: from.versionMinId,
      versionMin: from.versionMin,
      versionMaxId: from.versionMaxId,
      versionMax: from.versionMax,
      helperBorders: from.helperBorders != null ? [...from.helperBorders] : null,
      helperImages: from.helperImages != null ? [...from.helperImages] : null,
      helperTexts: from.helperTexts != null ? [...from.helperTexts] : null,
      helperBoxes: from.helperBoxes != null ? [...from.helperBoxes] : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type.toString().split('.')[1],
        'triggerType': triggerType.toString().split('.')[1],
        'creationDate': creationDate != null ? creationDate.toIso8601String() : null,
        'lastUpdateDate': lastUpdateDate != null ? lastUpdateDate.toIso8601String() : null,
        'priority': priority,
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

@HiveType(typeId: 4)
class HelperBorderEntity {

  @HiveField(0)
  int id;

  @HiveField(1)
  String color;

  @HiveField(2)
  String key;

  @HiveField(3)
  String style;

  @HiveField(4)
  double width;

  HelperBorderEntity({this.id, this.color, this.key, this.style, this.width});

  Map<String, dynamic> toJson() => {
        'id': id,
        'color': color,
        'key': key,
        'style': style,
        'width': width,
      };

  HelperBorderEntity copy() => HelperBorderEntity(
    id: id,
    color: color,
    key: key,
    style: style,
    width: width,
  );

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

@HiveType(typeId: 5)
class HelperImageEntity {

  @HiveField(0)
  int id;

  @HiveField(1)
  String key;

  @HiveField(2)
  String url;

  Map<String, dynamic> toJson() => {
        'id': id,
        'key': key,
        'url': url,
      };

  HelperImageEntity({this.id, this.key, @required this.url});

  HelperImageEntity copy() => HelperImageEntity(
      id: id,
      key: key,
      url: url
  );

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

@HiveType(typeId: 6)
class HelperTextEntity {

  @HiveField(0)
  int id;

  @HiveField(1)
  String fontColor;

  @HiveField(2)
  String fontFamily;

  @HiveField(3)
  String fontWeight;

  @HiveField(4)
  String key;

  @HiveField(5)
  String value;

  @HiveField(6)
  int fontSize;

  HelperTextEntity({
    this.id,
    this.fontColor,
    this.fontFamily,
    this.fontWeight,
    this.key,
    this.value,
    this.fontSize,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'fontColor': fontColor,
        'fontFamily': fontFamily,
        'fontWeight': fontWeight,
        'fontSize': fontSize,
        'key': key,
        'value': value,
      };

  HelperTextEntity copy() => HelperTextEntity(
    id: id,
    fontColor: fontColor,
    fontFamily: fontFamily,
    fontWeight: fontWeight,
    key: key,
    value: value,
    fontSize: fontSize
  );

  @override
  bool operator ==(Object other) =>
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

@HiveType(typeId: 7)
class HelperBoxEntity {
  @HiveField(0)
  int id;

  @HiveField(1)
  String backgroundColor;

  @HiveField(2)
  String key;

  HelperBoxEntity({
    this.id,
    @required this.backgroundColor,
    this.key,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'backgroundColor': backgroundColor,
        'key': key,
      };

  HelperBoxEntity copy() => HelperBoxEntity(
    id: this.id,
    backgroundColor: this.backgroundColor,
    key: this.key
  );

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
