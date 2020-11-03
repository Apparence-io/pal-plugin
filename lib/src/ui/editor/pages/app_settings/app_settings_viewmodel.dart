import 'package:flutter/widgets.dart';
import 'package:mvvm_builder/mvvm_builder.dart';

class AppSettingsModel extends MVVMModel {
  Size headerSize;
  String appVersion;
  String appName;
  bool appIconAnimation;
  bool isSendingAppIcon;
  bool isLoadingAppInfo;
  String appIconUrl;
  String appIconId;

  AppSettingsModel({
    this.headerSize,
    this.appVersion,
    this.appName,
    this.appIconAnimation,
    this.isSendingAppIcon,
    this.isLoadingAppInfo,
  });
}



