import 'package:package_info/package_info.dart';
import 'package:pal/src/services/client/versions/version.dart';

class PackageVersionReader {

  PackageInfo info;

  PackageVersionReader() {
    init();
  }

  Future<void> init() async {
    info = await PackageInfo.fromPlatform();
  }

  String get version => info.version;

  String get appName => info.appName;

  AppVersion get appVersion => AppVersion.fromString(info.version);
}
