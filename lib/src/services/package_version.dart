import 'package:package_info/package_info.dart';

class PackageVersionReader {
  PackageInfo info;

  Future<void> init() async {
    info = await PackageInfo.fromPlatform();
  }

  String get version => info.version;

  String get appName => info.appName;
}
