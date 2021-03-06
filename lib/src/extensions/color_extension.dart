import 'package:flutter/material.dart';

extension HexColor on Color {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  String toHex() => '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';

  static bool isHexColor(String? hexString) {
    if(hexString == null)
      return false;
    RegExp hexColor = RegExp(r'(^((0x){0,1}|#{0,1})([0-9A-F]{8}|[0-9A-F]{6})$)');
    return hexColor.hasMatch(hexString);
  }
}
