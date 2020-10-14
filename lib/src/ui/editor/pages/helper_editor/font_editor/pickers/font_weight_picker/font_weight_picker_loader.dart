import 'package:flutter/widgets.dart';

class FontWeightMapper {
  static Map<String, FontWeight> map = {
    'Thin': FontWeight.w100,
    'Extra-light': FontWeight.w200,
    'Light': FontWeight.w300,
    'Normal': FontWeight.w400,
    'Medium': FontWeight.w500,
    'Semi-bold': FontWeight.w600,
    'Bold': FontWeight.w700,
    'Extra-bold': FontWeight.w800,
    'Black': FontWeight.w900,
  };

  static String getFontKey(FontWeight fontWeight) {
    if (fontWeight == null) {
      return 'Normal';
    }

    String key;
    for (var entry in map.entries) {
      if (fontWeight == entry.value) {
        key = entry.key;
        break;
      }
    }
    return key;
  }

  static FontWeight getFontWeight(String key) {
    return map[key];
  }
}
