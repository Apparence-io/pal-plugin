import 'package:flutter/widgets.dart';
import 'package:mvvm_builder/mvvm_builder.dart';

class AppSettingsModel extends MVVMModel {
  Size headerSize;
  String appVersion;
  bool appIconAnimation;
  bool isSendingAppIcon;
  
  AppSettingsModel({
    this.headerSize,
    this.appVersion,
    this.appIconAnimation,
    this.isSendingAppIcon,
  });
}