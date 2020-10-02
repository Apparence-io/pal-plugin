import 'package:flutter/widgets.dart';
import 'package:mvvm_builder/mvvm_builder.dart';

class AppSettingsModel extends MVVMModel {
  GlobalKey headerKey;
  Size headerSize;
  String appVersion;
  bool appIconAnimation;
  
  AppSettingsModel({
    this.headerKey,
    this.headerSize,
    this.appVersion,
    this.appIconAnimation,
  });
}