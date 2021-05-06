import 'package:package_info_plus/package_info_plus.dart';
import 'package:pal/src/services/client/versions/version.dart';

class PackageVersionReader {
  late PackageInfo info;

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
