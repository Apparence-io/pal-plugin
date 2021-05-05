import 'package:flutter/foundation.dart';
import 'package:package_info/package_info.dart';
import 'package:pal/src/services/client/versions/version.dart';

class PackageVersionReader {
  late PackageInfo info;

  PackageVersionReader() {
    init();
  }

  Future<void> init() async {
    if (!kIsWeb) {
      info = await PackageInfo.fromPlatform();
    } else {
      // hardcoded version for Flutter web which can not
      // access to package info from native
      info = new PackageInfo(
        appName: '',
        packageName: '',
        version: '',
        buildNumber: '',
      );
    }
  }

  String get version => info.version;

  String get appName => info.appName;

  AppVersion get appVersion => AppVersion.fromString(info.version);
}
