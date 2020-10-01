import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:mvvm_builder/mvvm_builder.dart';

class AppSettingsModel extends MVVMModel {
  Uint8List appIcon;
  GlobalKey headerKey;
  Size headerSize;
  
  AppSettingsModel({
    this.appIcon,
    this.headerKey,
    this.headerSize,
  });
}